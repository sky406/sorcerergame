extends Resource
class_name effectDat
@export var icon:Image
@export var effectName:String
@export var isTimed:bool
@export var lifeTime:float = 1
@export var stackable:bool = false
@export var effects:Array[targetAttr]
@export var display:bool = true
@export var overtime:bool
@export var overtimeInterval:float
@export var overtimeEffect:PackedScene

func summerizeEffects():
	var summary:String =""
	for i in effects:
		var unformatted = "%s: %s"
		var formated = unformatted.format % [i.targetAttribute,i.ammount]
		summary+=formated+"\n"
	return summary
