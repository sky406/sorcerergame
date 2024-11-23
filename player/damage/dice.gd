# Dice.gd
extends Node

# Method to roll dice based on a dice notation string
static func roll(dice_string: String) -> int:
	# Example: Parse "2d6+3"
	var parts = dice_string.split("d")
	if parts.size() < 2:
		return 0 # Invalid format

	var num_dice = int(parts[0])
	var dice_and_modifier = parts[1].split("+")
	var dice_sides = int(dice_and_modifier[0])
	var modifier = 0
	if dice_and_modifier.size() > 1:
		modifier = int(dice_and_modifier[1])


	var total = 0
	for i in range(num_dice):
		total += randi_range(1, dice_sides) # Roll each die

	return total + modifier
