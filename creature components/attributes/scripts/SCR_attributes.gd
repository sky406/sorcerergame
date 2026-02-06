class_name Attributes extends Node
# const die = preload("res://weapons/weapon components/scripts/die.gd")
# const Effect = preload("res://effects/template/effect.tscn")
var resistances:Array[Resistance] 
var damageImmunities:Array[damageType] 
var effectResistances:Array[String]
var attributes:Dictionary[String,Attribute]
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
# this comment just prevents a bug in vscode don't pay any attention to it):



func _ready():
	pass

func _setAttributes(attribs:Dictionary[String,Attribute]):
	attributes = attribs

	# setting all derived attributes
	attributes["hp"] = Attribute.new(calculateHP(),false,9999,true)


func getAttributeValue(attribName:String) -> float:
	# ):
	if attribName in attributes:
		return attributes[attribName].total()
	else:
		print("attribute does not exist")
		return 0 

# attribute functions
func getMod(attribName:String) -> float:
	# ): 
	var atttribval = getAttributeValue(attribName)
	return floor((float(atttribval)-10)/2.0)

func calculateHP() -> float:
	# ):
	var conMod:float = getMod("constitution")
	var level:float = getAttributeValue("level")
	return 6+conMod + ((level-1)*3+conMod)

func prof():
	var level = getAttributeValue("level")
	return ceil(level/4.0)+1

func applyEffect(effect:Effect) -> bool:
	var targetAttr = effect.targetAttribute
	if targetAttr in attributes:
		var effectApplied = attributes[targetAttr].addEffect(effect)
		return effectApplied
	else:
		return false

# func maxenergy():
# 	var lvlbonus = 0
# 	match level:
# 		1:lvlbonus = 4
# 		2:lvlbonus = 6
# 		3:lvlbonus = 14
# 		4:lvlbonus = 17
# 		5:lvlbonus = 27
# 		6:lvlbonus = 32
# 		7:lvlbonus = 38
# 		8:lvlbonus = 44
# 		9:lvlbonus = 57
# 		10:lvlbonus = 64
# 		11:lvlbonus = 73
# 		12:lvlbonus = 73
# 		13:lvlbonus = 83
# 		14:lvlbonus = 83
# 		15:lvlbonus = 94
# 		16:lvlbonus = 94
# 		17:lvlbonus = 107
# 		18:lvlbonus = 114
# 		19:lvlbonus = 123
# 		20:lvlbonus = 133
# 		_:lvlbonus = 133+level
# 	return lvlbonus
