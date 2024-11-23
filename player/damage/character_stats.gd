# CharacterStats.gd
extends Node

# Properties
@export var health: int = 100
@export var attack: int = 10
@export var resistances: Dictionary = {} # e.g., {"Fire": 0.2, "Bludgeoning": 0.1}
@export var vulnerabilities: Array = [] # e.g., ["Aether"]
@export var immunities: Array = [] # e.g., ["Poison"]
var lingering_effects: Array = []

# Apply damage based on resistances, vulnerabilities, and immunities
func take_damage(damage_type: DamageType, attacker_stats: Dictionary):
	# Create a dictionary for defender stats (this instance, 'self')
	var defender_stats = {
		"health": health,
		"attack": attack,
		"resistances": resistances,
		"vulnerabilities": vulnerabilities,
		"immunities": immunities
	}

	# Calculate damage using the defender's stats
	var damage = damage_type.calculate_damage(attacker_stats, defender_stats)
	health -= damage
	if health < 0:
		health = 0

	# Apply any lingering effect
	damage_type.apply_lingering_effect(self)

# Add a lingering effect to the character
func add_lingering_effect(effect: LingeringEffect):
	lingering_effects.append(effect)

# Update lingering effects each frame
func update_lingering_effects(delta: float):
	for effect in lingering_effects:
		effect.apply_effect(self)
		if effect.update(delta):
			effect.remove_effect(self)
			lingering_effects.erase(effect)
