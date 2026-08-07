class_name Attributes 
extends Node


# Stores resistances against status effects or other non-damage effects.
var effectResistances:Array[String]

# Stores all character attributes, such as constitution, level, and HP.
var attributes:Dictionary[String,Attribute]

# To keep track of repeated hits
var recentDamageHits: Dictionary[int, Array] = {}

# To store runtime effect states
var activeEffects: Array[Dictionary] = []


#region ''' signals '''
# Emitted when an attribute changes.
signal attribute_changed(newattr)

# Emitted when a new effect is added to the character.
signal effect_added(effect)

# Emitted when an effect is removed from the character.
signal effect_removed(effect)

# Emitted whenever current HP or maximum HP changes.
signal hp_adjusted(
	old_max,
	old_current,
	new_max,
	new_current
)

# Emitted when a stat changes.
signal stat_changed(stat, old, new)

# Emitted when an effect is resisted.
signal effect_resisted(effect: Effect)

# Emitted when an effect is successfully applied.
signal effect_applied(effect: Effect)

# Emitted when the character's maximum HP changes. 
signal maxHpChanged(old, new)

# Emitted when damage actually removes HP.
signal damage_taken(
	amount: float,
	damage_type: DamageTypes.types
)

# Emitted when incoming damage is completely blocked by immunity or global invulnerability.
signal damage_immune(
	damage_type: DamageTypes.types
)

# Emitted when HP is restored.
signal healed(
	old,
	new,
	amount
)

# Emitted once when HP transitions from above 0 to 0.
signal died

# This comment just prevents a bug in vscode don't pay any attention to it):
#endregion

# Runs when Attribute node enters the scene tree; currently performs no setup.
func _ready():
	pass

# Stores the provided attributes and creates the character's derived HP attribute.
func _setAttributes(attribs:Dictionary[String,Attribute]):
	# Attributes.attribute is set to the param, attribs
	attributes = attribs

	# Calculates the character's maximum HP and stores it as an HP attribute.
	attributes["hp"] = HP.new(calculateMaxHP())
	
	# Send out signal that the "hp" attribute changed.
	attribute_changed.emit("hp")

# Returns the total calculated value of the requested attribute, or 0 if it does not exist.
func getAttributeValue(attribName:String) -> float:
	if attribName in attributes:
		return attributes[attribName].total()
	else:
		print("attribute does not exist")
		return 0.0 

# Returns the modifier for an attribute using its total value.
func getMod(attribName:String) -> float:
	# Stores the total value of the requested attribute.
	var attribval = getAttributeValue(attribName)
	
	# Converts an attribute score into a modifier, using the familiar D&D-style formula.
	return floor((float(attribval)-10)/2.0)

# Calculates character's max HP using constitution and level
# Was func calculateHP(), but what type of HP wasn't specified
func calculateMaxHP() -> float: 
	# Stores the character's constitution modifier, local variable that only exists while calculateHP()
	var conMod:float = getMod("constitution")
	
	# Stores the character's current level.
	var level:float = getAttributeValue("level")
	
	# Max HP
	return (
		6.0
		+ conMod
		+ (
			(level - 1.0) * 3.0
			+ conMod
		)
	)

# Returns the HP resource stored inside attributes["hp"].
# Should use this helper instead of repeatedly doing: attributes["hp"]
func getHP() -> HP:
	var hp_attribute := attributes["hp"]

	if hp_attribute is HP:
		return hp_attribute

	push_error(
		"Attributes does not contain a valid HP resource."
	)

	return null


# Returns current HP.
# HP.value, from Attribut, represents current health.
func getCurrentHP() -> float:
	var hp := getHP()

	if hp == null:
		return 0.0

	return hp.value


# Returns maximum HP.
func getMaxHP() -> float:
	var hp := getHP()

	if hp == null:
		return 0.0

	return hp.maxValue

# Wrapper lets Attributes emit signals and detect death, while HP remains responsible for the actual HP calculation.
func applyDamage(
	amount: float,
	damage_type: DamageTypes.types
) -> float:
	var hp := getHP()

	if hp == null:
		return 0.0

	# Save values before damage so signals can report the change.
	var old_max := hp.maxValue
	var old_current := hp.value

	# Remember whether this attack should be completely blocked.
	# HP.dealDamage() checks too, but Attribute script needs to know why zero damage happened so it can emit damage_immune.
	var was_immune := (
		hp.invulnerable
		or damage_type in hp.immune
	)

	# HP handles:
	# - invulnerability
	# - immunity
	# - vulnerability
	# - resistance
	# - one-shot protection
	# - current HP reductions
	var actual_damage := hp.dealDamage(
		amount,
		damage_type
	)

	# Save values returned/adusted by HP attribute
	var new_max := hp.maxValue
	var new_current := hp.value

	# Tell listeners that damage was completely blocked.
	if was_immune:
		damage_immune.emit(
			damage_type
		)

	# Notify health bars/UI, whenever this damage attempt changes or potentially attempts to change, HP.
	hp_adjusted.emit(
		old_max,
		old_current,
		new_max,
		new_current
	)

	# Report the amount of HP actually removed.
	#
	# Example:
	# target has 5 HP
	# incoming damage = 20
	# HP.dealDamage() returns 5
	damage_taken.emit(
		actual_damage,
		damage_type
	)

	# Only emit death when transitioning from alive to dead.
	#
	# This avoids repeatedly emitting died when an already-dead character receives more damage.
	if (
		old_current > 0.0
		and new_current <= 0.0
	):
		died.emit()

	# Return actual damage dealt
	return actual_damage


# Restore part of character health.
func applyHealing(amount: float) -> float:
	var hp := getHP()

	if hp == null:
		return 0.0

	var old_max := hp.maxValue
	var old_current := hp.value

	var actual_healing := hp.heal(amount)

	hp_adjusted.emit(
		old_max,
		old_current,
		hp.maxValue,
		hp.value
	)

	healed.emit(
		old_current,
		hp.value,
		actual_healing
	)

	return actual_healing


# Restores the character to full health.
func fullHeal() -> void:
	var hp := getHP()

	if hp == null:
		return

	var old_max := hp.maxValue
	var old_current := hp.value

	hp.fullHeal()

	hp_adjusted.emit(
		old_max,
		old_current,
		hp.maxValue,
		hp.value
	)


# Changes maximum HP through the HP resource while emitting the appropriate signals.
func setMaxHP(
	new_maximum: float,
	preserve_percentage: bool = false
) -> void:
	var hp := getHP()

	if hp == null:
		return

	var old_max := hp.maxValue
	var old_current := hp.value

	hp.setMaxValue(
		new_maximum,
		preserve_percentage
	)

	hp_adjusted.emit(
		old_max,
		old_current,
		hp.maxValue,
		hp.value
	)

	# Only emit this when maximum HP actually changed.
	if old_max != hp.maxValue:
		maxHpChanged.emit(
			old_max,
			hp.maxValue
		)


# Helper for checking whether the character is dead.
func isDead() -> bool:
	var hp := getHP()

	if hp == null:
		return true

	return hp.isDead()


# Attempts to apply an effect to its target attribute and returns whether it succeeded.
func applyEffect(effect: Effect) -> bool:
	# Gets the name of the attribute this effect is meant to modify.
	var target_attribute := effect.targetAttribute

	# Stop if the target attribute does not exist.
	if target_attribute not in attributes:
		return false

	# Prevent the same non-stackable effect from being applied more than once.
	if (
		not effect.stackable
		and effect in attributes[
			target_attribute
		].effects_applied
	):
		return false

	# Attempts to apply the effect to the target attribute.
	var was_applied := attributes[
		target_attribute
	].addEffect(effect)

	# Only emit effect signals if the effect was successfully applied.
	if was_applied:
		# Notifies listeners that an effect was added.
		effect_added.emit(effect)

		# Notifies listeners that an effect was successfully applied.
		effect_applied.emit(effect)

	# Returns whether the effect was successfully applied.
	return was_applied

# Calculates the character's proficiency bonus based on level.
func prof() -> float:
	# Stores the character's current level.
	var level = getAttributeValue("level")
	
	# Character proficiency
	return ceil(level/4.0)+1


# func maxenergy():
# 	var lvlbonus = 0
# 	match level:
# 		1:lvlbonus = 4
# 		2:lvlbonus = 6
# 		3:lvlbonus = 14
# 		4:lvlbonus = 17
# 		5:lvlbonus = 27
# 		6:lvlbonus = 32
# 		7:lvlbonus = 38
# 		8:lvlbonus = 44
# 		9:lvlbonus = 57
# 		10:lvlbonus = 64
# 		11:lvlbonus = 73
# 		12:lvlbonus = 73
# 		13:lvlbonus = 83
# 		14:lvlbonus = 83
# 		15:lvlbonus = 94
# 		16:lvlbonus = 94
# 		17:lvlbonus = 107
# 		18:lvlbonus = 114
# 		19:lvlbonus = 123
# 		20:lvlbonus = 133
# 		_:lvlbonus = 133+level
# 	return lvlbonus
# TODO: connect the attributes to the hp and the res of the player stuff
