# HP class, attribute of player, enemy, NPC, etc
class_name HP 
extends Attribute


#region exported vars
@export_group("details")
@export_group("settings")

# Maximum HP
@export var maxValue:float

# One shot protection if the player will be able to be one shot iv over a certain ammount of health
@export var oneShotProc:bool = true

## One-shot protection only works while current HP is above this value.
@export var oneShotThreshold:float = 1
#endregion


#region global vars
# Usig the shared DamageTypes enum as the key instead of strings.
# This avoids typo/casing issues like "fire", "Fire", "firre", etc.
# Resistance values are stored as decimals: 0.25 = 25% resistance.
var resistances: Dictionary[int, float] = {}

# Same enum-keyed approach as resistances.
# Vulnerability values are also decimals: 0.50 = 50% extra damage.
# Example: 100 incoming damage with 0.50 vulnerability becomes 150 damage.
var vulnerabilities: Dictionary[int, float] = {}

# Invulnerable means ALL incoming damage is blocked, regardless of damage type.
var invulnerable:bool = false

# Immunities are stored as actual DamageTypes enum values instead of strings, so only valid damage categories can be used.
var immune: Array[DamageTypes.types] = []
#endregion


# Removed _ready()
# HP is a Resource, not a Node, so _ready() is not guaranteed to run the way it does for scene-tree Nodes.
func _init(max_hp: float = 1.0) -> void:
	# Anything required for HP initialization is therefore done here.
	limit = 999999.0
	dice = false

	# Prevent invalid HP resources such as 0 or negative maximum HP.
	maxValue = max(max_hp, 1.0)

	# New HP objects start fully healed.
	fullHeal()


# Return HP after damage is dealt
func dealDamage(
	damage: float,
	damage_type: DamageTypes.types
) -> float:
	# Ignore zero/negative damage.
	if damage <= 0.0:
		return 0.0

	# Global invulnerability blocks all damage types.
	if invulnerable:
		return 0.0

	# Type-specific immunity blocks only this particular damage type.
	if damage_type in immune:
		return 0.0

	# Store the current value of damage to deal in modified_damage
	var modified_damage := damage

	# Vulnerability increases incoming damage.
	#
	# Example:
	# vulnerability = 0.50
	# damage = 100
	# 100 * (1 + 0.50) = 150
	#
	# This keeps vulnerability flexible instead of forcing all vulnerabilities to always mean exactly double damage.
	var vulnerability := clampf(
		vulnerabilities.get(damage_type, 0.0),
		0.0,
		100.0
	)

	# Modify damage give any vulnerabilities
	modified_damage *= 1.0 + vulnerability


	# Resistance reduces incoming damage.
	#
	# Example:
	# resistance = 0.25
	# damage = 100
	# 100 * (1 - 0.25) = 75
	#
	# The original implementation multiplied by resistance / 100
	# Which meant 25% resistance caused the target to take only 25 damage instead of reducing the damage by 25%.
	#
	# Resistance is capped at 99%, matching the design rule that resistance cannot make a target completely immune.
	var resistance := clampf(
		resistances.get(damage_type, 0.0),
		0.0,
		0.99
	)
	
	# Modify how much damage the character receives if they are resistant to damage type
	modified_damage *= 1.0 - resistance

	# Prevent any combination of modifiers from producing negative damage.
	modified_damage = max(modified_damage, 0.0)


	# Implemented the one-shot protection settings 
	#
	# Example:
	# current HP = 80
	# incoming damage = 100
	# one-shot protection is active
	#
	# Result:
	# damage is limited to 79 and the target survives at 1 HP.
	if (
		oneShotProc
		and value > oneShotThreshold
		and modified_damage >= value
	):
		modified_damage = max(value - 1.0, 0.0)

	# Store current HP (Attribute.value) before changing it
	var old_value := value


	# Clamp current HP so it never goes below 0 or above maxValue.
	# The original implementation used, value -= damageDealt, which allowed HP values such as -40.
	value = clampf(
		value - modified_damage,
		0.0,
		maxValue
	)


	# Return the amount of HP ACTUALLY removed.
	# Matters when incoming damage is larger than remaining HP.
	#
	# Example:
	# HP = 5
	# incoming damage = 20
	#
	# Current HP only changes by 5, so this returns 5 rather than 20.
	# That gives DamageSystem/UI/signals an accurate value.
	return old_value - value


# Partial healing did not exist previously; only fullHeal() existed.
# Keeping healing inside HP gives damage/healing the same current/max HP rules.
func heal(amount: float) -> float:
	if amount <= 0.0:
		return 0.0

	var old_value := value

	# Healing cannot exceed maximum HP.
	value = clampf(
		value + amount,
		0.0,
		maxValue
	)

	# Return actual HP restored.
	#
	# Example:
	# HP = 98 / 100
	# heal(20)
	#
	# HP becomes 100 and this returns 2.
	return value - old_value


# Restore current HP directly to maximum HP.
func fullHeal():
	value = maxValue


# Centralized way to change maximum HP without leaving current HP in an invalid state.
func setMaxValue(
	new_maximum: float,
	preserve_percentage: bool = false
) -> void:
	var old_maximum := maxValue
	var old_current := value

	maxValue = max(new_maximum, 1.0)


	# Optional behavior for effects/stat changes that increase/decrease maximum HP.
	#
	# Example:
	# 50 / 100 HP = 50%
	# Max HP changes to 200
	#
	# preserve_percentage = true
	# -> current HP becomes 100 / 200
	#
	# preserve_percentage = false
	# -> current HP stays 50 / 200
	if preserve_percentage and old_maximum > 0.0:
		value = maxValue * (
			old_current / old_maximum
		)
	else:
		# If maximum HP decreases below current HP, clamp current HP down to the new maximum.
		value = min(
			old_current,
			maxValue
		)


# Central helper so other systems do not have to repeat: hp.value <= 0
func isDead() -> bool:
	return value <= 0.0
