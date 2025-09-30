class_name Effect extends Resource
@export_group("details")
@export var icon:Texture2D
@export var effectName:String #i feel like i should make all effects have unique names, self note add all of these to docuementation
# @export var effect:targetAttr #remove this later
@export var targetAttribute:String

@export_group("settings")
@export var isTimed:bool
@export var lifeTime:float = 1
@export var stackable:bool = false
@export var display:bool = true #detemines weather or not this appears when applied
@export var overtime:bool # detemines weather the effects adds something overtime 
@export var overtimeInterval:float

@export_subgroup("numerical effects")
@export var ammount:float
@export_enum("add","multiply") var applymode:String

@export_subgroup("dice settings")
@export var dice:Array[Die]
@export var diceAdd:bool = true

@export_enum(
	"bludgeouning",
	"slashing",
	"piercing",
	"fire",
	"cold",
	"lightning",
	"aether",
	"blight",
	"physical",
	"elemental",
	"celestial",
	"spell",
	"non-magical",
	"all",
	"special"
	)var affects:String


var overtimeEffect:Callable = func():
	print("you forgot to actually add the effect dumbass")

# func summerizeEffects():
# 	var summary:String =""
# 	var unformatted = "%s: %s"
# 	var formated = unformatted.format % [effect.targetAttribute,effect.ammount]
# 	summary+=formated+"\n"
# 	return summary
