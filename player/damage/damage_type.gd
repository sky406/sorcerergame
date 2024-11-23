# DamageType.gd - whenever the player or an NPC gets damaged, as long as they are not immune to the damage type, they take a random number of damage determined by a dice roll. 
extends Resource

# Damage Types:
#	Physical
#	Elemental
#	Celestial

# Lingering effects per Damage Type, lasts for a short period and can scale in effectiveness by the creature's attack attribute
#	Physical:
#		bludgeouning - [dazed, stunned]
#		slashing - [bleeding]
#		pierceing - [bleeding, weakened]
#	Elemental:
#		fire - [burn, scorched]
#		cold - [frostbite, frozen]
#		lighting - [shocked]
#	Celestial:
#		aether
#		void - [blighted]

# Resistance:
#	Armour
#	Natual resistance
#	Effects

# Vulnerability:
# Final damage = Damage from damage type * 2

# Immunity:
# Final damage = 0 from damage type

# Final damage = Damage from dice roll
#				+ Damage bonuses from items + 
#				+ Effect bonuses
#				- [(Damage resistance as a % like 43/100 or decimal like 0.43) x (Damage)]

# Properties
@export var name: String = ""
@export var lingering_effect: String = "" # e.g., "Dazed", "Burn", etc., or empty if none
@export var dice_roll: String = "1d6" # e.g., "1d6+2" format for damage calculation

# Calculate damage based on attacker's and defender's stats
func calculate_damage(attacker_stats: Dictionary, defender_stats: Dictionary) -> int:
	# Use Dice class to roll the dice string (e.g., "1d6+2")
	var base_damage = Dice.roll(dice_roll)
	
	# Apply attack bonus and resistances/vulnerabilities
	var attack_bonus = attacker_stats.get("attack", 0)
	var resistance = defender_stats.get("resistances", {}).get(name, 0)
	var vulnerability = 0
	if defender_stats.get("vulnerabilities", []).has(name):
		vulnerability = 0.5

	var immunity = 0
	if defender_stats.get("immunities", []).has(name):
		immunity = 1
	
	# Adjust damage based on resistance, vulnerability, or immunity
	if immunity:
		return 0 # No damage if immune
	var final_damage = (base_damage + attack_bonus) * (1 - resistance + vulnerability)
	return max(final_damage, 0) # No negative damage

# Apply the lingering effect, if it exists, to the target
func apply_lingering_effect(target):
	if lingering_effect:
		var effect = LingeringEffect.new()
		effect.name = lingering_effect
		target.add_lingering_effect(effect)
