extends Node
# const die = preload("res://weapons/weapon components/scripts/die.gd")
# const Effect = preload("res://effects/template/effect.tscn")
@export var resistances:Array[Resistance] 
@export var damageImmunities:Array[damageType] 
@export var effectResistances:Array[String]
# var appliedEffects:Array[Effect]
@export var attributes:Array[Attribute]
# ''' signals '''
signal attribute_changed(newattr)
signal effect_added(effect)
signal effect_removed(effect)
signal hp_adjusted(old_max,old_current,new_max,new_current)
signal stat_changed(stat,old,new)
signal effect_resisted(effect:Effect)
signal effect_applied(effect:Effect)
signal dealtDamage(old,new,resisted:bool)
signal maxHpChanged(old,new)
signal damageImmune(damage)
signal healed(old,new,ammount)
# visual bug reducing comment):
######## attributes #######

#core attributes
# @export var strength:float = 8
# @export var dexterity:float = 12
# @export var constitution:float = 13
# @export var inteligence:float = 11
# @export var wisdom:float = 10
# @export var charisma:float = 18
@export var level:float = 0
@export var speed:float = 30

func _ready():
	# ):
	#set up the attributes
	attributes.push_back(Attribute.new("strength",8))
	attributes



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

#  hp stuff

var maxHp:float = 1

func _calculatemaxhp():
	var health:float = 6 + get_mod(constitution)
	if level >= 1:
		health += (level-1) * (3 + get_mod(constitution))

	return ceil(health) # while the hp is a float it is still supposed to rounded up

var maxHP = _calculatemaxhp()
var currentHP = maxHp

func _dealDamage(ammount:float,type:damageType):
	var oldHP = currentHP

	for dt in damageImmunities:
		if type.type == dt.type:
			damageImmune.emit(type)
			print("immune to damage")
			return
	for dt in resistances:
		if type.type == dt.type:
			ammount -= ammount*dt.resPercent
			currentHP -= ammount
			currentHP = ceil(clamp(currentHP,0,maxHP))
			dealtDamage.emit(oldHP,currentHP,true)
			return
	currentHP -= ammount
	currentHP = ceil(clamp(currentHP,0,maxHP)) #always remember to make sure it's rounded
	if currentHP != oldHP:
		dealtDamage.emit(oldHP,currentHP)

func _heal(ammount:float):
	var oldHp = currentHP
	currentHP += ammount
	healed.emit(oldHp,currentHP,ammount)

func hpPercent():
	return currentHP/maxHP

func _changeMaxHp(newmax:float):
	var oldmax = maxHP
	var hpPerc = hpPercent()
	maxHp = newmax
	# for now the current hp scales with max hp
	currentHP = maxHP*hpPerc
	maxHpChanged.emit(oldmax,maxHP)

# effect stuff


# func _applyEffect(effect:Effect):
# 	# TODO rename the effectdat script to effects so that the attubutes node does all the heavy lifitn on effect management
# 	if effect.effectName in effectResistances:
# 		effect_resisted.emit(effect.effectName)
# 		return
# 	elif effect in appliedEffects and not effect.stackable:
# 		print("effect cannot stack")
# 		effect_resisted.emit(effect.effectName)
# 		return
# 	else:
# 		appliedEffects.push_back(effect)

# 		if effect.isTimed:
# 			var effectTimer = load("res://effects/effectTimer.tscn")
# 			effectTimer.linkedEffect = effect.effectName
# 			effectTimer.effect_end.connect(_onEffectEnd)
# 			# effectTimer
# 			call_deferred("add_child",effectTimer)
# 		# TODO add the overtime code somewhere here
# 		effect_applied.emit(effect)
# 		# for eff in effect.effects:
# 		# 	# break down where the attibue belongs an just adds it in 
# 		# 	var attribute:targetAttr.attribute
# 		# 	var mode:targetAttr.mode
			



# func _onEffectEnd(effectname):
# 	for effect in appliedEffects:
# 		if effect.effectname == effectname:
			
# 			appliedEffects.erase(effect)
# 			break
