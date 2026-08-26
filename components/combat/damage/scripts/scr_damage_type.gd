""" 
Data only 
Answers the question: "What damage type is this?"
"""
class_name DamageType
extends Resource

# Stores the damage type, such as slashing, piercing, fire, etc.
@export var type: DamageTypes.types

# Stores an optional custom name used when displaying this damage type.
@export var display_name: String = ""

# Stores the Die resource that determines how this damage type rolls its base damage.
@export var die: Die

# Stores the lingering effects that this damage type is capable of causing.
@export var possible_lingering: Array[Effect] = []


# Rolls this damage type's dice and returns the total base damage rolled.
func roll_base_damage() -> int:
	# A damage type without a die cannot roll damage, so return 0.
	if die == null:
		return 0

	# Roll the configured dice and store each individual result.
	var rolls := die.roll()

	# Keeps track of the combined value of all dice rolled.
	var total := 0

	# Add each individual die result to the total damage.
	for roll_value in rolls:
		total += int(roll_value)

	# Return the combined result of all dice rolls.
	return total


# Returns the custom display name, or generates one from the damage type if none was provided.
func get_display_name() -> String:
	# Use the manually assigned display name if one exists.
	if not display_name.is_empty():
		return display_name

	# Convert the damage type enum into a readable capitalized name.
	return DamageTypes.types.keys()[type].capitalize()
