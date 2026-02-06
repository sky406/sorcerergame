extends Resource
class_name InvItem
@export var itemName:String
@export var itemIcon:Texture2D
@export_multiline var itemDescription:String
@export var ammount:int = 1 #note this only really applies to consumables
@export_enum("consumable","weapon","gloves","boots","cloak","hat","key item","pin") var itemType:String
@export var itemScene:PackedScene #this just refers to the scene associated with the item
