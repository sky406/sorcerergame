extends Node
const die = preload("res://weapons/weapon components/scripts/die.gd")
const stateffect = preload("res://effects/template/effect.tscn")

signal  attribute_changed(newattr)
#TODO check if you still need the old attribute
signal effect_added(effectName)
signal effect_removed(effectName)
signal hp_adjusted(old_max,old_current,new_max,new_current)
signal stat_changed(stat,old,new)



@export var strength:int = 8
@export var dexterity:int = 12
@export var constitution:int = 13
@export var inteligence:int = 11
@export var widsom:int = 10
@export var charisma:int = 18
@export var level = 0
var maxhp = 6+calculate_mod(constitution) + 0*3+calculate_mod(constitution)
var hp:float = maxhp
var bonuses = {
	"damage":{"all":0},
	"speed":{"number":0,"percent":0}
}


func calculate_mod(attribute:int):
	return int(floor((float(attribute)-10)/2.0))

func _ready():
	connect("effect_added",_on_effect_added)

var staticEffects:Array = []


func addEffect(effect:Array):
	var addedeffect = stateffect.instantiate()
	for i in effect:
		match i["attribute"]:
			"strength":
				strength +=i["bonus"]
			"dexterity":
				dexterity +=i["bonus"]
			"constitution":
				constitution += i["bonus"]
			"inteligence":
				inteligence +=i["bonus"]
			"wisdom":
				widsom += i["bonus"]
			"charisma":
				charisma += i["bonus"]
			"damage":
				if i["type"] in bonuses["damage"]:
					bonuses["damage"][i["type"]] = i["bonus"]
			"speed":
				pass
			_: 
				print(i)
				print("error reading attribute")
		# if i has "overtime":
		# 	pass

		# TODO add full functionality to to this if it works 	
	# call_deferred("add_child",effect)
	effect_added.emit("fuck")
	print("attribute changed")
	print(constitution)

func removeEffect(effect):
	call_deferred("remove_child",effect)
	effect_removed.emit()


func on_effect_remove():
	pass

func on_effect_overtime_timeout(effect):
	pass
# TODO rework the effect script to just apply to the attributes


func _on_effect_added(effect):
	print("help")
	var hpPercent:float = ((hp/maxhp)*100)/100
	print(hpPercent)
	maxhp = 6+calculate_mod(constitution) + 0*3+calculate_mod(constitution)
	hp = maxhp*hpPercent
	print("it worked i guess")
	attribute_changed.emit(null,hp)
	print(hp)
	print(maxhp)
