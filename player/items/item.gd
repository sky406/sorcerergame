extends Resource
class_name Item
enum Type {Consumable,Equipment,Weapon,Misc}
@export var itemName:String
@export var itemIcon:Texture2D
# @export var equipEffect:AddEffect #make the effect actually the type for this
@export_multiline var itemDescription:String
var itemType:Type
