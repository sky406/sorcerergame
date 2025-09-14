extends Object
class_name Attribute
enum Type{
	strength,
	dexterity,
	constitution,
	inteligence,
	wisdom,
	charisma,
}

@export var name:Type
@export var limit:int = 20

var bonus:int
var overflow:int

func addEffect(effect:effectDat):
	pass
func removeEffect(effect:effectDat):
	pass
