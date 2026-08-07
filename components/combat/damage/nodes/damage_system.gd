"""
DamageSystem 
-> rolls dice 
    + resist/vuln/immune 
    + lingering threshold  
    + adds effect
-> affect HP

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

Final damage 
= Damage from dice roll
	+ Flat bonuses from items + 
	+ Effect bonuses
	- Damage resistance
"""
extends Node


@export var lingering_window_ms: int = 3000
@export var lingering_hits_required: int = 3


func apply_hit(
	attacker: Attributes,
	defender: Attributes,
	components: Array[DamageComponent]
) -> int:
	var total_damage := 0

	for component in components:
		total_damage += _apply_component(
			attacker,
			defender,
			component
		)

	return total_damage


func _apply_component(
	attacker: Attributes,
	defender: Attributes,
	component: DamageComponent
) -> int:
	if component == null:
		return 0

	var damage_type := component.damage_type

	if damage_type == null:
		return 0

	if defender.isDead():
		return 0

	var rolled_damage := damage_type.roll_base_damage()

	var scaling_bonus := 0

	if component.scaling_attribute != "none":
		scaling_bonus = int(
			attacker.getMod(
				component.scaling_attribute
			)
		)

	var proficiency_bonus := 0

	if component.add_proficiency:
		proficiency_bonus = int(attacker.prof())

	var raw_damage : int = max(
		rolled_damage
		+ component.flat_bonus
		+ component.effect_bonus
		+ scaling_bonus
		+ proficiency_bonus,
		0
	)

	var actual_damage := int(
		round(
			defender.applyDamage(
				raw_damage,
				damage_type.type
			)
		)
	)

	if actual_damage > 0:
		_track_for_lingering(
			defender,
			damage_type
		)

	return actual_damage


func apply_hit_detailed(
	attacker: Attributes,
	defender: Attributes,
	components: Array[DamageComponent]
) -> Dictionary:
	var total_damage := 0
	var component_reports: Array[Dictionary] = []

	var health_before_attack := defender.getCurrentHP()

	for component in components:
		var report := _apply_component_detailed(
			attacker,
			defender,
			component
		)

		component_reports.append(report)

		# Use actual damage removed from HP.
		total_damage += int(report["final_damage"])

	return {
		"total_damage": total_damage,
		"health_before": health_before_attack,
		"health_after": defender.getCurrentHP(),
		"components": component_reports
	}


func _apply_component_detailed(
	attacker: Attributes,
	defender: Attributes,
	component: DamageComponent
) -> Dictionary:
	# Safe default report so the test scene can still display
	# something even when the component is invalid.
	var report := {
		"damage_type_name": "Unknown",
		"damage_type": -1,

		"dice_rolls": [],
		"dice_total": 0,

		"scaling_attribute": "none",
		"scaling_bonus": 0,

		"proficiency_bonus": 0,

		"flat_bonus": 0,
		"effect_bonus": 0,

		"raw_damage": 0,

		"resistance": 0.0,
		"is_vulnerable": false,
		"is_immune": false,

		"final_damage": 0,

		"health_before": defender.getCurrentHP(),
		"health_after": defender.getCurrentHP(),

		"lingering_count_before": 0,
		"lingering_count_after": 0,
		"lingering_hits_required": lingering_hits_required,

		"lingering_applied": false,
		"lingering_effect_name": ""
	}

	if component == null:
		return report

	var damage_type := component.damage_type

	if damage_type == null:
		return report

	if defender.isDead():
		return report


	var type := damage_type.type

	report["damage_type"] = type
	report["damage_type_name"] = (
		damage_type.get_display_name()
	)

	report["flat_bonus"] = component.flat_bonus
	report["effect_bonus"] = component.effect_bonus

	report["scaling_attribute"] = (
		component.scaling_attribute
	)


	# ---------------------------------------------------------
	# Defence information is now owned by HP.
	# We read it only for the debug report.
	# HP.dealDamage() performs the actual calculations.
	# ---------------------------------------------------------

	var defender_hp := defender.getHP()

	if defender_hp == null:
		return report

	report["is_immune"] = (
		defender_hp.invulnerable
		or type in defender_hp.immune
	)

	report["resistance"] = float(
		defender_hp.resistances.get(
			type,
			0.0
		)
	)

	report["is_vulnerable"] = (
		type in defender_hp.vulnerabilities
	)


	# If the defender is immune, HP.dealDamage() would return 0 anyway.
	# Returning here also means an immune hit does not contribute
	# toward lingering buildup.
	if report["is_immune"]:
		return report


	# ---------------------------------------------------------
	# Roll dice
	# ---------------------------------------------------------

	var rolls: Array = []

	if damage_type.die != null:
		rolls = damage_type.die.roll()

	var dice_total := 0

	for roll_value in rolls:
		dice_total += int(roll_value)

	report["dice_rolls"] = rolls.duplicate()
	report["dice_total"] = dice_total


	# ---------------------------------------------------------
	# Scaling bonus
	#
	# This replaces attacker.attack.
	#
	# Each DamageComponent chooses which attribute it scales from.
	# Example:
	# sword -> strength
	# bow -> dexterity
	# fire enchantment -> none
	# ---------------------------------------------------------

	var scaling_bonus := 0

	if component.scaling_attribute != "none":
		scaling_bonus = int(
			attacker.getMod(
				component.scaling_attribute
			)
		)

	report["scaling_bonus"] = scaling_bonus


	# ---------------------------------------------------------
	# Optional proficiency
	# ---------------------------------------------------------

	var proficiency_bonus := 0

	if component.add_proficiency:
		proficiency_bonus = int(
			attacker.prof()
		)

	report["proficiency_bonus"] = proficiency_bonus


	# ---------------------------------------------------------
	# Raw damage
	#
	# No resistance/vulnerability here.
	# HP.dealDamage() owns those rules now.
	# ---------------------------------------------------------

	var raw_damage: int = maxi(
		dice_total
		+ component.flat_bonus
		+ component.effect_bonus
		+ scaling_bonus
		+ proficiency_bonus,
		0
	)

	report["raw_damage"] = raw_damage


	# ---------------------------------------------------------
	# Apply damage through Attributes -> HP
	#
	# HP handles:
	# immunity
	# invulnerability
	# vulnerability
	# resistance
	# one-shot protection
	# HP subtraction
	# ---------------------------------------------------------

	var health_before := defender.getCurrentHP()

	var actual_damage := defender.applyDamage(
		raw_damage,
		type
	)

	var health_after := defender.getCurrentHP()

	report["health_before"] = health_before
	report["health_after"] = health_after

	report["final_damage"] = int(
		round(actual_damage)
	)


	# ---------------------------------------------------------
	# Lingering buildup
	#
	# Only successful damage contributes.
	# ---------------------------------------------------------

	if actual_damage > 0.0:
		var lingering_result := (
			_track_for_lingering_detailed(
				defender,
				damage_type
			)
		)

		report["lingering_count_before"] = (
			lingering_result["count_before"]
		)

		report["lingering_count_after"] = (
			lingering_result["count_after"]
		)

		report["lingering_applied"] = (
			lingering_result["applied"]
		)

		report["lingering_effect_name"] = (
			lingering_result["effect_name"]
		)

	return report


func _track_for_lingering(
	defender: Attributes,
	damage_type: DamageType
) -> void:
	if damage_type.possible_lingering.is_empty():
		return

	var type := damage_type.type
	var current_time := Time.get_ticks_msec()

	if not defender.recentDamageHits.has(type):
		defender.recentDamageHits[type] = []

	var hit_times: Array = defender.recentDamageHits[type]
	hit_times.append(current_time)

	while (
		not hit_times.is_empty()
		and current_time - int(hit_times[0])
			> lingering_window_ms
	):
		hit_times.pop_front()

	if hit_times.size() < lingering_hits_required:
		return

	var effect: Effect = (
		damage_type.possible_lingering.pick_random()
	)

	defender.applyEffect(effect)
	hit_times.clear()


func _track_for_lingering_detailed(
	defender: Attributes,
	damage_type: DamageType
) -> Dictionary:
	var type := damage_type.type
	var current_time := Time.get_ticks_msec()

	# recentDamageHits now lives on Attributes rather than CombatantStats.
	if not defender.recentDamageHits.has(type):
		defender.recentDamageHits[type] = []

	var hit_times: Array = (
		defender.recentDamageHits[type]
	)

	# Remove expired hits before recording the new one.
	while (
		not hit_times.is_empty()
		and current_time - int(hit_times[0])
			> lingering_window_ms
	):
		hit_times.pop_front()

	var count_before := hit_times.size()

	hit_times.append(current_time)

	var count_after := hit_times.size()

	var applied := false
	var effect_name := ""

	if count_after >= lingering_hits_required:
		var effect: Effect = (
			_apply_lingering(
				defender,
				damage_type
			)
		)

		if effect != null:
			applied = true
			effect_name = effect.effectName

		# Start a fresh buildup cycle after the effect triggers.
		hit_times.clear()
		count_after = 0

	return {
		"count_before": count_before,
		"count_after": count_after,
		"applied": applied,
		"effect_name": effect_name
	}


func _apply_lingering(
	defender: Attributes,
	damage_type: DamageType
) -> Effect:
	if damage_type.possible_lingering.is_empty():
		return null

	var effect: Effect = (
		damage_type.possible_lingering.pick_random()
	)

	if effect == null:
		return null

	var applied := defender.applyEffect(effect)

	if not applied:
		return null

	return effect
