extends Resource
class_name Attribute
enum Type{
	strength,
	dexterity,
	constitution,
	inteligence,
	wisdom,
	charisma,
}

@export var name:String
@export var limit:float= 20.0
@export var value:float

var bonus:int
var multiplier:float = 0
# var overflow:int
var effects_applied:Array[Effect]

func addEffect(effect:Effect):
	var eff = effect.effect
	if effect in effects_applied and not effect.stackable:
		return false
	else:
		if eff.targetAttribute != name:
			print("eff doesn't match")
			return false
		else:
			effects_applied.push_back(effect)
			match eff.applymode:
				0:# add
					bonus+= eff.ammount
					print("added")
				1:#multiply
					multiplier += eff.ammount
					print("multiplied")
			return true

func removeEffect(effect:Effect):
	var eff = effect.effect
	if not (effect in effects_applied):
		print("effect not applied")
		return false
	else:
		effects_applied.erase(effect)
		match eff.applymode:
			0: # still add 
				bonus -= eff.ammount*value
			1: #multiply
				multiplier-= eff.ammount

func _init(
	attribname:String="unnamed attribute",
	attribvalue:int = 10,
	attriblimit:int = 20 
	):
		name = attribname
		value = attribvalue
		limit = attriblimit
func total():
	if multiplier == 0:
		return ceil(clamp(value+bonus,0,limit))
	else:
		return ceil(clamp(value+bonus,0,limit)*multiplier)
