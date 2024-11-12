class_name ItemDat
extends Resource
enum itemType {Weapon,Consumable,Glove,Cloak,Pin,Hat,Boots} 

@export var type:itemType
@export var name:String
@export_multiline var itemDescription:String
@export var icon:Texture2D
