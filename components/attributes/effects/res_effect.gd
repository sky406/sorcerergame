class_name Effect extends Resource
@export_category("details")
## if there 
@export var icon:Texture2D = load("res://assets/placeholder sprites/placeholder empty effect-Recovered.png")

## every effect needs a name, name this one fivehead.
@export var effectName:String = "unnamed effect"

## the attribute targeted by the effect
@export var targetAttribute:String = "nothing"

@export_group("settings")
## does the effect expire after a set period
@export var isTimed:bool = true
## how long the effects lasts before expiring 
@export var lifeTime:float = 1
@export var stackable:bool = false

## detemines weather or not this appears when applied
@export var display:bool = true 

@export_subgroup("overtime effects")
## this determines if the effect triggers overtime 
@export var overtime:bool 

## how often the effect is triggered
@export var overtimeInterval:float 


@export_subgroup("numerical effects")
@export var ammount:float

## add will simply add the ammount the the value of the stat.[br]
## multiply will add the cumilative multiplier of the attrubute
@export_enum("add","multiply") var applymode:String

@export_subgroup("dice settings")
@export var addDice:bool = true
@export var dice:Array[Die]

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


# var overtimeEffect:Callable = func():
# 	print("you forgot to actually add the effect dumbass")

# func summerizeEffects():
# 	var summary:String =""
# 	var unformatted = "%s: %s"
# 	var formated = unformatted.format % [effect.targetAttribute,effect.ammount]
# 	summary+=formated+"\n"
# 	return summary
