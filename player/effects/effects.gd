# Status effects do lots of things
#	change an NPC or player's attributes such as strength or constitution
#	add extra effects to damage or spell effects
#	apply effects based on specific actions:
#		effects can be applied to creatures through effect fields, equipping items and taking damage from certain sources

# Things effects can change 
#	attributes: 
#		this involves shit such as strength, wisdom and other core attributes
#	immunities and resistances
#	spell effects and damage 


extends Node
const statEffect = preload("res://effects/template/effect.tscn")
@export var effects:Array = []
signal effect_added(effect:Dictionary)
signal effect_removed(effect:Dictionary)

func _ready():
	pass



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
	effect_added.emit(neweffect)
	# check if effect in list
	var activeeffects = listeffects()
	if neweffect.effectname in activeeffects and !neweffect.isstackable:
		print("effect already applied")
		return

	# apply effect
	var appliedeffects = []
	for i in neweffect.effect:
		#TODO add a check for type resitances and shit idk 
		appliedeffects.append(i)
	print("applied effects")
	print(appliedeffects)
	effects.append({neweffect["name"]:appliedeffects})
	# active_effects.append({neweffect.effectname:appliedeffects})
	
	# TODO APPLY THE effects and connect the signals
	# neweffect.connect("effect_added",_on_effect_added)
	# neweffect.connect("effect_removed",_on_effect_removed)
	# neweffect.connect("effect_interval_timeout",_on_effect_interval)

	# applying the effect

	

	call_deferred("add_child",neweffect)
	effect_added.emit({neweffect["name"]:appliedeffects})

func affects(attribute:String):
	var values = []
	for i in effects:
		for effect in i[i.keys()[0]]:
			if effect["attribute"] == attribute:
				values.append(effect["value"])
	print("affected values counted")
	print(attribute+str(values))
	print(effects)
	return clamp(Global.sumarray(values),1,50)
