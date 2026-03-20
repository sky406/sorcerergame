""" 
Data only 
Answers the question: "What damage type is this?"
"""
extends Resource
class_name DamageType

@export var id: String = ""                 # "fire", "slashing"
@export var display_name: String = ""       # "Fire", "Slashing"

# NEW: Die resource instead of "1d6"
@export var die: Die                        # assign a .tres Die in the editor

# Optional if you want types that roll multiple different dice sets:
# @export var dice: Array[Die] = []

@export var possible_lingering: Array[String] = []  # ["burn","scorched"]

func roll_base_damage() -> int:
	if die == null:
		return 0
	var rolls: Array = die.roll()         # returns Array of ints
	var total := 0
	for r in rolls:
		total += int(r)
	return total
