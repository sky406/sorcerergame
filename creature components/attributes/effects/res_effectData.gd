extends Resource
class_name effectDat
@export var icon:Texture2D
@export var effectName:String #i feel like i should make all effects have unique names, self note add all of these to docuementation
@export var isTimed:bool
@export var lifeTime:float = 1
@export var stackable:bool = false
@export var effects:Array[targetAttr]
@export var display:bool = true #detemines weather or not this appears under the healthbar
@export var overtime:bool # detemines weather the effects adds something overtime 
@export var overtimeInterval:float
@export var overtimeEffect:Script

func summerizeEffects():
	var summary:String =""
	for i in effects:
		var unformatted = "%s: %s"
		var formated = unformatted.format % [i.targetAttribute,i.ammount]
		summary+=formated+"\n"
	return summary