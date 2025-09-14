extends Resource
class_name WeaponDat
enum weaponType{staff,melee,ranged}
@export var equipEffect:effectDat
@export var type:weaponType
@export var weaponName:String
@export_multiline var wesponDescription:String
#the weapon scene is just the url of the weapon in the file, tho it can be used to load the weapon if it's not taken from the weapon itself 
