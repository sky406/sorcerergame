extends Node
const die = preload("res://weapons/weapon components/scripts/die.gd")
@onready var effectman =$effects
@export var resistances = []

#TODO check if you still need the old attribute
signal attribute_changed(newattr)
signal effect_added(effect)
signal effect_removed(effect)
signal hp_adjusted(old_max,old_current,new_max,new_current)
signal stat_changed(stat,old,new)
signal effect_resisted(effectName)
signal effect_applied(effectName)

func addEffect(effect:Array):
	# check if effect is resisted then add to effects 
	effectman.addEffect(effect)
	attribute_changed.emit("ahh")
	effect_added.emit(effect)

# this part just makes calculating attribute changes might need some reworks eventually
func get_attribute(attribute:String):
	var effecttotal = effectman.affects(attribute)
	match attribute:
		"strength":
			return strength+effecttotal
		"dexterity":
			return dexterity+effecttotal
		"constitution":
			return constitution+effecttotal
		"inteligence":
			return inteligence+effecttotal
		"wisdom":
			return wisdom+effecttotal
		"charisma": 
			return charisma+effecttotal
		"speed":
			return speed+effecttotal
		
		"maxhp":
			return hp+effecttotal
		_:
			print("attribute not found")

######## attributes #######

#core attributes
@export var strength:int = 8
@export var dexterity:int = 12
@export var constitution:int = 13
@export var inteligence:int = 11
@export var wisdom:int = 10
@export var charisma:int = 18
@export var level:int = 0
@export var speed:float = 30

# attribute functions
func get_mod(attribute:int):
	return int(floor((float(attribute)-10)/2.0))

func prof():
	return int(floor(float(level/4.0)))+1
func maxenergy():
	var lvlbonus = 0
	match level:
		1:lvlbonus = 4
		2:lvlbonus = 6
		3:lvlbonus = 14
		4:lvlbonus = 17
		5:lvlbonus = 27
		6:lvlbonus = 32
		7:lvlbonus = 38
		8:lvlbonus = 44
		9:lvlbonus = 57
		10:lvlbonus = 64
		11:lvlbonus = 73
		12:lvlbonus = 73
		13:lvlbonus = 83
		14:lvlbonus = 83
		15:lvlbonus = 94
		16:lvlbonus = 94
		17:lvlbonus = 107
		18:lvlbonus = 114
		19:lvlbonus = 123
		20:lvlbonus = 133
		_:lvlbonus = 133+level
	return lvlbonus
func calculatemaxhp():
	var health = 6+get_mod(get_attribute("constitution"))
	if level >1:
		health += (level-1)*3+get_mod((get_attribute("constitution"))) 
	return health

# derived attributes
var maxhp = 0
var hp = 0

func on_effect_added():
	print("new effect detected")
	print(get_attribute("constitution"))
	print("hi hi hellow aihahahkakhakhjakjahk")

func _ready():
	effectman.connect("effect_added",on_effect_added)
	maxhp = calculatemaxhp()
	hp = maxhp


func _on_attribute_changed(newattr):
	pass # Replace with function body.
	# hp checkup 
	var hppercent = hp/maxhp
	maxhp = calculatemaxhp()
	hp = maxhp*hppercent
