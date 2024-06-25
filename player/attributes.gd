extends Node
const die = preload("res://weapons/weapon components/scripts/die.gd")
const statEffect = preload("res://effects/template/effect.tscn")

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
var effects = {}

func calculate_mod(attribute:int):
	return int(floor((float(attribute)-10)/2.0))

func _ready():
	connect("effect_added",_on_effect_added)

var currenteffectsEffects:Dictionary =  {}

func listeffects():
	var effectlist = []
	var children = get_children()
	for i in children:
		for prop in i.get_property_list():
			if prop["name"] == "Effect.gd":
				effectlist.append(i.effectname)
				# i.callout()
	return effectlist

func addEffect(effect:Dictionary):
	var neweffect = statEffect.instantiate()
	if effect["properties"]["canstack"] == false:
		var currenteffects = listeffects()
		if effect["name"] in currenteffects:
			print("effect already applied")
			return
	neweffect.effectname = effect["name"]
	neweffect.effect = effect["effects"]
	neweffect.icon = effect["icon"]
	# properties
	var properties = effect["properties"]
	neweffect.displayeffect = properties["displayeffect"]
	neweffect.timedeffect = properties["timedeffect"]
	neweffect.lifetime = properties["lifetime"]
	neweffect.isstackable = properties["canstack"]
	neweffect.overtime = effect["overtime"]
	# TODO APPLY THE effects and connect the signals
	neweffect.connect("effect_added",_on_effect_added)
	# neweffect.connect("overtime_effect_timeout",_on_overtime_timeout)
	neweffect.connect("effect_removed",_on_effect_removed)
	neweffect.connect("effect_interval_timeout",_on_effect_interval)

	call_deferred("add_child",neweffect)
	# effects.append(neweffect)
	
	effect_added.emit(neweffect.effectname)
	# print("attribute changed")
	# print(constitution)
	print(listeffects())

func removeEffect(effect):
	call_deferred("remove_child",effect)
	effect_removed.emit()


func on_effect_remove():
	pass

func on_effect_overtime_timeout(effectName):
	pass
# TODO rework the effect script to just apply to the attributes

func on_effect_timeout(effectName):
	pass


func _on_effect_added(effectName):
	pass
	# print("help")
	# var hpPercent:float = ((hp/maxhp)*100)/100
	# print(hpPercent)
	# maxhp = 6+calculate_mod(constitution) + 0*3+calculate_mod(constitution)
	# hp = maxhp*hpPercent
	# print("it worked i guess")
	# attribute_changed.emit(null,hp)
	# print(hp)
	# print(maxhp)

func _on_effect_interval(effectName):
	print(effectName)

func _on_effect_removed(effectName):
	pass
