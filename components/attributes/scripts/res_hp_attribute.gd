class_name HP extends Attribute
#region exported vars
@export_group("details")
@export var maxValue:float


@export_group("settings")

## one shot protection: if the player will be able to be one shot iv over a certain ammount of health
@export var oneShotProc:bool = true

## how low the creatures hp can be before oneshot protection is automatically turned off 
@export var oneShotThreshold:float = 1

#region global vars
var resistances:Dictionary
var vulnerabilities:Dictionary
var invulnerable:bool = false
var immune:Array[String]


func _init(maxHp:float):
	maxValue = maxHp
	fullHeal()

func _ready():
	limit = 9999
	dice = false


func dealDamage(damage:float,type:String) -> float:
	# ):
	## calculates damage dealt and returns the total damage dealt 
	if type in immune:
		return 0
	else:
		var damageDealt = damage
		
		if type in vulnerabilities:
			damageDealt *= 1 + vulnerabilities[type]/100
		
		if type in resistances:
			damageDealt *= resistances[type]/100
		
		value -= damageDealt
		
		return damageDealt

func fullHeal():
	value = maxValue