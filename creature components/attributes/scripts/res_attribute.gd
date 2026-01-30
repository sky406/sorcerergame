class_name Attribute extends Resource

@export_group("details")
@export var limit:float= 20.0
@export var value:float

@export_group("settings")
@export var acceptEffects:bool = true

@export_subgroup("accepted effect types")
@export var additiveBonus:bool = true
@export var multipliedBonus:bool
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
	if (acceptEffects and not effect in effects_applied) or (effect in effects_applied and effect.stackable):
		if additiveBonus and effect.applymode == "add":
			bonus += effect.ammount
		
		if multipliedBonus and effect.applymode == "multiply":
			multiplier += effect.ammount

		if dice:
			if effect.diceAdd:
				if effect.affects in dieadd:
					dieadd[effect.affects].append_array(effect.dice)
				else:
					dieadd[effect.affects] = effect.dice

			else:
				if effect.affects in diesubtract:
					diesubtract[effect.affects].append_array(effect.dice)
				else:
					diesubtract[effect.affects] = effect.dice
		
		effects_applied.push_back(effect)
		return true

	else:
		return false

func removeEffect(effect:Effect):
	if effect in effects_applied:
		if additiveBonus:
			bonus -= effect.ammount
		
		if multipliedBonus:
			multiplier -= effect.ammount

		if dice:
			if effect.diceAdd:
				for die in effect.dice:
					dieadd[effect.affects].erase(die)
			else :
				for die in effect.dice:
					diesubtract[effect.affects].erase(die)


		


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
