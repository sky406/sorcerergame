class_name Attribute extends Resource

@export_group("details")
## base value for the attribute 
@export var value:float
## maximum possible for the attribute
@export var limit:float= 20.0


@export_group("settings")
## set this to false for static effects
@export var acceptEffects:bool = true

@export_subgroup("accepted effect types")
@export var additiveBonus:bool = true
@export var multipliedBonus:bool = false
@export var dice:bool = false


var bonus:float
var multiplier:float = 0
var dieadd:Dictionary[String,Array]
var diesubtract:Dictionary[String,Array]
# var overflow:int
var effects_applied:Array[Effect]

func _init(
	attribvalue:float = 10,
	usesDice:bool=false,
	attriblimit:float = 20,
	alllowEffects:bool = true
	):
		value = attribvalue
		limit = attriblimit
		dice = usesDice
		acceptEffects = alllowEffects

func addEffect(effect:Effect) -> bool:
	# Effects can only be applied if:
	# - this Attribute accepts effects and the effect is not already applied
	# OR
	# - the effect is already applied but is explicitly stackable.
	var can_apply := (
		acceptEffects
		and effect not in effects_applied
	) or (
		effect in effects_applied
		and effect.stackable
	)

	# Early return instead of nesting the entire function
	if not can_apply:
		return false

	# Apply additive effects to this Attribute's bonus.
	if additiveBonus and effect.applymode == "add":
		bonus += effect.ammount

	# Apply multiplicative effects to this Attribute's multiplier.
	if multipliedBonus and effect.applymode == "multiply":
		multiplier += effect.ammount

	# Some Attributes can also have dice added to or removed from them.
	if dice:
		var target_dictionary := (
			dieadd
			if effect.addDice
			else diesubtract
		)

		if effect.affects in target_dictionary:
			target_dictionary[
				effect.affects
			].append_array(effect.dice)
		else:
			# duplicate() avoids storing the exact same Array reference from the Effect resource inside the Attribute.
			target_dictionary[
				effect.affects
			] = effect.dice.duplicate()

	# Keep track of the effect so it can later be removed.
	effects_applied.push_back(effect)

	return true

# Removes an applied effect and reverses any bonuses, multipliers, or dice changes it previously added.
func removeEffect(effect: Effect) -> void:
	# Stop immediately if this effect is not currently applied.
	if effect not in effects_applied:
		return

	# The old version could potentially subtract the effect from both bonus and multiplier if both flags are true.
	# Remove the effect's value from the additive bonus if it was applied as an additive effect.
	if additiveBonus and effect.applymode == "add":
		bonus -= effect.ammount
	# Remove the effect's value from the multiplier if it was applied as a multiplicative effect.
	if multipliedBonus and effect.applymode == "multiply":
		multiplier -= effect.ammount

	# Remove any dice that were added or subtracted by this effect.
	# Instead of duplicating the same loop twice, it decides to use dieadd or diesubtract then runs the removal logic once.
	if dice:
		# Choose which dice dictionary the effect originally modified.
		var target_dictionary := (
			dieadd
			if effect.addDice
			else diesubtract
		)

		# Check that the dictionary contains an entry for the attribute/stat affected by the effect.
		# If effect.affects doesn't exist as a key, the old code is more likely to cause an error.
		if effect.affects in target_dictionary:
			# Go through every die that was added by this effect.
			for effect_die in effect.dice:
				# Remove that die from the appropriate dice list.
				# Old function, as shown, never actually removes the effect from effects_applied.
				target_dictionary[
					effect.affects
				].erase(effect_die)

	# Remove the effect itself from the list of currently applied effects.
	effects_applied.erase(effect)
	
func total():
	if multiplier == 0:
		return ceil(clamp(value+bonus,0,limit))
	else:
		return ceil(clamp(value+bonus,0,limit)*multiplier)

func rollDieBonus(type:String="all"):
	var added = 0
	var subtracted = 0 
	if type in dieadd:
		for die in dieadd[type]:
			added+=Global.sumArray(die.roll())
	if type in diesubtract:
		for die in diesubtract[type]:
			subtracted += Global.sumArray(die.roll())
	
	return added - subtracted
