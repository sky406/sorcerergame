extends Resource
class_name targetAttr
# enum attribute{
# 	strength,
# 	dexterity,
# 	constitution,
# 	charisma,
# 	inteligence,
# 	wisdom,
# 	speed,
# 	energy,
# 	effect_resisitance,
# 	effect_hit,
# 	melee_damage,
# 	spell_damage,
# 	damage_dice}

enum mode{add,multiply}
enum multiplyType {base,total}

@export var targetAttribute:String
@export var ammount:float
@export var applymode:mode = mode.add

# func _addToAttribute(attr):
# 	match applymode:
# 		mode.add:
# 			var new_ammount = attr*ammount
# 			return new_ammount
# 		mode.multiply:
# 			var new_ammount = attr+ammount
# 			return new_ammount

# func _removeFromAttribute(attr):
# 	match applymode:
# 		mode.add:
# 			var new_ammount = attr-ammount
# 			return new_ammount
# 		mode.multiply:
# 			var new_ammount = attr/ammount
# 			return new_ammount
