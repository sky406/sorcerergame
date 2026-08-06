"""
DamageSystem 
-> rolls dice 
    + resist/vuln/immune 
    + lingering threshold 
-> updates CombatantStats 
    + adds LingeringEffect

DamageType.gd
- whenever the player or an NPC gets damaged, 
- as long as they are not immune to the damage type, 
- they take a random number of damage determined by a dice roll. 
Damage Types:
	Physical
	Elemental
	Celestial

Lingering effects per Damage Type, lasts for a short period and can scale in effectiveness by the creature's attack attribute
	Physical:
		bludgeouning - [dazed, stunned]
		slashing - [bleeding]
		pierceing - [bleeding, weakened]
	Elemental:
		fire - [burn, scorched]
		cold - [frostbite, frozen]
		lighting - [shocked]
	Celestial:
		aether
		void - [blighted]

Resistance:
	Armour
	Natual resistance
	Effects

Vulnerability:
Final damage = Damage from damage type * 2

Immunity:
Final damage = 0 from damage type

Final damage = Damage from dice roll
				+ Damage bonuses from items + 
				+ Effect bonuses
				- [(Damage resistance as a % like 43/100 or decimal like 0.43) x (Damage)]

"""
extends Node

@export var lingering_window_ms: int = 3000
@export var lingering_hits_required: int = 3
@export var lingering_duration: float = 5.0

func apply_hit(
	attacker: CombatantStats,
	defender: CombatantStats,
	components: Array[DamageComponent]
) -> int:
	var report := apply_hit_detailed(attacker, defender, components)
	return int(report["total_damage"])


func apply_hit_detailed(
	attacker: CombatantStats,
	defender: CombatantStats,
	components: Array[DamageComponent]
) -> Dictionary:
	var total_damage := 0
	var component_reports: Array[Dictionary] = []
	var health_before_attack := defender.health

	for component in components:
		var report := _apply_component_detailed(
			attacker,
			defender,
			component
		)

		component_reports.append(report)
		total_damage += int(report["final_damage"])

	return {
		"total_damage": total_damage,
		"health_before": health_before_attack,
		"health_after": defender.health,
		"components": component_reports
	}


func _apply_component_detailed(
	attacker: CombatantStats,
	defender: CombatantStats,
	component: DamageComponent
) -> Dictionary:
	var report := {
		"damage_type_id": "unknown",
		"damage_type_name": "Unknown",
		"dice_rolls": [],
		"dice_total": 0,
		"attack_bonus": attacker.attack,
		"flat_bonus": component.flat_bonus,
		"effect_bonus": component.effect_bonus,
		"raw_damage": 0,
		"resistance": 0.0,
		"damage_after_resistance": 0,
		"is_vulnerable": false,
		"is_immune": false,
		"final_damage": 0,
		"health_before": defender.health,
		"health_after": defender.health,
		"lingering_count_before": 0,
		"lingering_count_after": 0,
		"lingering_hits_required": lingering_hits_required,
		"lingering_applied": false,
		"lingering_effect_id": ""
	}

	var damage_type: DamageType = component.damage_type

	if damage_type == null:
		return report

	var damage_type_id := damage_type.id
	var damage_type_name := damage_type.display_name

	if damage_type_name.is_empty():
		damage_type_name = damage_type_id.capitalize()

	report["damage_type_id"] = damage_type_id
	report["damage_type_name"] = damage_type_name

	var hit_times_before: Array = defender.recent_hits.get(
		damage_type_id,
		[]
	)

	report["lingering_count_before"] = hit_times_before.size()

	# Immunity prevents both damage and lingering buildup.
	if defender.immunities.has(damage_type_id):
		report["is_immune"] = true

		defender.emit_signal(
			"damaged",
			0,
			damage_type_id
		)

		return report

	var rolls: Array = []

	if damage_type.die != null:
		rolls = damage_type.die.roll()

	var dice_total := 0

	for roll_value in rolls:
		dice_total += int(roll_value)

	report["dice_rolls"] = rolls.duplicate()
	report["dice_total"] = dice_total

	var raw_damage := (
		dice_total
		+ component.flat_bonus
		+ component.effect_bonus
		+ attacker.attack
	)

	report["raw_damage"] = raw_damage

	var resistance := float(
		defender.resistances.get(
			damage_type_id,
			0.0
		)
	)

	resistance = clamp(resistance, 0.0, 0.99)

	report["resistance"] = resistance

	var damage_after_resistance := int(
		round(raw_damage * (1.0 - resistance))
	)

	report["damage_after_resistance"] = damage_after_resistance

	var final_damage := damage_after_resistance
	var is_vulnerable := defender.vulnerabilities.has(damage_type_id)

	report["is_vulnerable"] = is_vulnerable

	if is_vulnerable:
		final_damage *= 2

	final_damage = max(final_damage, 0)

	report["final_damage"] = final_damage

	defender.health = max(
		defender.health - final_damage,
		0
	)

	report["health_after"] = defender.health

	defender.emit_signal(
		"damaged",
		final_damage,
		damage_type_id
	)

	var lingering_result := _track_for_lingering_detailed(
		defender,
		damage_type,
		attacker
	)

	report["lingering_count_after"] = lingering_result["count_after"]
	report["lingering_applied"] = lingering_result["applied"]
	report["lingering_effect_id"] = lingering_result["effect_id"]

	return report


func _track_for_lingering(
	defender: CombatantStats,
	damage_type: DamageType,
	attacker: CombatantStats
) -> void:
	_track_for_lingering_detailed(
		defender,
		damage_type,
		attacker
	)


func _track_for_lingering_detailed(
	defender: CombatantStats,
	damage_type: DamageType,
	attacker: CombatantStats
) -> Dictionary:
	var damage_type_id := damage_type.id
	var current_time := Time.get_ticks_msec()

	if not defender.recent_hits.has(damage_type_id):
		defender.recent_hits[damage_type_id] = []

	var hit_times: Array = defender.recent_hits[damage_type_id]
	hit_times.append(current_time)

	while (
		not hit_times.is_empty()
		and current_time - int(hit_times[0]) > lingering_window_ms
	):
		hit_times.pop_front()

	var count_after := hit_times.size()
	var applied := false
	var effect_id := ""

	if count_after >= lingering_hits_required:
		effect_id = _apply_lingering_detailed(
			defender,
			damage_type,
			attacker
		)

		applied = not effect_id.is_empty()
		hit_times.clear()
		count_after = 0

	return {
		"count_after": count_after,
		"applied": applied,
		"effect_id": effect_id
	}


func _apply_lingering(
	defender: CombatantStats,
	damage_type: DamageType,
	attacker: CombatantStats
) -> void:
	_apply_lingering_detailed(
		defender,
		damage_type,
		attacker
	)


func _apply_lingering_detailed(
	defender: CombatantStats,
	damage_type: DamageType,
	attacker: CombatantStats
) -> String:
	if damage_type.possible_lingering.is_empty():
		return ""

	var effect_id: String = damage_type.possible_lingering[
		randi_range(
			0,
			damage_type.possible_lingering.size() - 1
		)
	]

	var effect := LingeringEffect.new()

	effect.id = effect_id
	effect.duration = lingering_duration
	effect.potency = max(
		1.0,
		attacker.attack / 10.0
	)

	defender.apply_lingering(effect)

	return effect_id
