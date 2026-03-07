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
class_name DamageSystem

@export var lingering_window_ms: int = 3000
@export var lingering_hits_required: int = 3
@export var lingering_duration: float = 5.0

func apply_hit(attacker: CombatantStats, defender: CombatantStats, components: Array[DamageComponent]) -> int:
	var total := 0

	for c in components:
		var dt: DamageType = c.damage_type
		if dt == null:
			continue

		var dtype_id := dt.id

		# Immunity
		if defender.immunities.has(dtype_id):
			defender.emit_signal("damaged", 0, dtype_id)
			continue

		# NEW: roll using Die system
		var rolled := dt.roll_base_damage()
		var raw := rolled + c.flat_bonus + c.effect_bonus + attacker.attack

		# Resistance (0..0.99)
		var resist := float(defender.resistances.get(dtype_id, 0.0))
		resist = clamp(resist, 0.0, 0.99)
		var after_resist := int(round(raw * (1.0 - resist)))

		# Vulnerability doubles
		var final := after_resist
		if defender.vulnerabilities.has(dtype_id):
			final *= 2

		final = max(final, 0)
		defender.health = max(defender.health - final, 0)
		total += final

		defender.emit_signal("damaged", final, dtype_id)

		_track_for_lingering(defender, dt, attacker)

	return total

func _track_for_lingering(defender: CombatantStats, dt: DamageType, attacker: CombatantStats) -> void:
	var dtype_id := dt.id
	var now := Time.get_ticks_msec()

	if not defender.recent_hits.has(dtype_id):
		defender.recent_hits[dtype_id] = []
	defender.recent_hits[dtype_id].append(now)

	# prune old hits
	var arr: Array = defender.recent_hits[dtype_id]
	while arr.size() > 0 and (now - arr[0]) > lingering_window_ms:
		arr.pop_front()

	# enough hits -> apply lingering
	if arr.size() >= lingering_hits_required:
		_apply_lingering(defender, dt, attacker)
		arr.clear()

func _apply_lingering(defender: CombatantStats, dt: DamageType, attacker: CombatantStats) -> void:
	if dt.possible_lingering.is_empty():
		return

	var effect_id: String = dt.possible_lingering[randi_range(0, dt.possible_lingering.size() - 1)]

	var e := LingeringEffect.new()
	e.id = effect_id
	e.duration = lingering_duration
	e.potency = max(1.0, attacker.attack / 10.0)

	defender.apply_lingering(e)
