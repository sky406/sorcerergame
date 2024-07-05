extends Node
const die = preload("res://weapons/weapon components/scripts/die.gd")
const statEffect = preload("res://effects/template/effect.tscn")
#TODO check if you still need the old attribute


#core attributes
@export var strength:int = 8
@export var dexterity:int = 12
@export var constitution:int = 13
@export var inteligence:int = 11
@export var wisdom:int = 10
@export var charisma:int = 18
@export var level:int = 0
@export var speed:float = 30

#effect bonuses
var item_bonuses:Dictionary = {
	"effects":[]
}
var energy_bonus:int = 0
var effectbonus = 0 
# derived attributes
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
	return lvlbonus + energy_bonus

func effectmod():
	return get_mod(charisma) + Funcsglobal.sumarray(item_bonuses["effects"])
var maxhp = (6+get_mod(constitution))+(level*3+get_mod(constitution))
var hp:float = maxhp
var energy:float = maxenergy()
# TODO clean up the derived stats a bit
# signals

signal attribute_changed(newattr)
signal effect_added(effectName)
signal effect_removed(effectName)
signal hp_adjusted(old_max,old_current,new_max,new_current)
signal stat_changed(stat,old,new)
signal effect_resisted(effectName)
signal effect_applied(effectName)


func _ready():
	connect("effect_added",_on_effect_added)

####### effect bullshit 
var active_effects = []

func listeffects():
	var effectlist = []
	var children = get_children()
	for i in children:
		for prop in i.get_property_list():
			if prop["name"] == "Effect.gd":
				effectlist.append(i.effectname)
				# i.callout()
	return effectlist

func addEffect(effect:Array):
	var neweffect = statEffect.instantiate()
	neweffect.build_effect(effect)
	effect_added.emit(neweffect.effectname)
	# check if effect in list
	var activeeffects = listeffects()
	if neweffect.effectname in activeeffects and !neweffect.isstackable:
		print("effect already applied")
		effect_resisted.emit(neweffect.effectname)
		return

	# apply effect
	var appliedeffects = []
	for i in neweffect.effect:
		#TODO add a check for type resitances and shit idk 
		appliedeffects.append(i)
	active_effects.append({neweffect.effectname:appliedeffects})
	
	# TODO APPLY THE effects and connect the signals
	neweffect.connect("effect_added",_on_effect_added)
	neweffect.connect("effect_removed",_on_effect_removed)
	neweffect.connect("effect_interval_timeout",_on_effect_interval)

	# applying the effect

	

	call_deferred("add_child",neweffect)
	effect_added.emit(neweffect.effectname)

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

# this part just makes calculating attribute changes might need some reworks eventually
func get_attribute(attribute:String):
	var effecttotal = 0
	for i in active_effects:
		if i.has("attribute"):
			if i["attribute"]==attribute:
				effecttotal+=i["value"]
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