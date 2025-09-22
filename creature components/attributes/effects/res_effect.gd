extends Resource
class_name Effect
@export var icon:Texture2D
@export var effectName:String #i feel like i should make all effects have unique names, self note add all of these to docuementation
@export var isTimed:bool
@export var lifeTime:float = 1
@export var stackable:bool = false
@export var effect:targetAttr
@export var display:bool = true #detemines weather or not this appears under the healthbar
@export var overtime:bool # detemines weather the effects adds something overtime 
@export var overtimeInterval:float
var overtimeEffect:Callable = func():
	print("you forgot to actually add the effect dumbass")

func summerizeEffects():
	var summary:String =""
	var unformatted = "%s: %s"
	var formated = unformatted.format % [effect.targetAttribute,effect.ammount]
	summary+=formated+"\n"
	return summary
