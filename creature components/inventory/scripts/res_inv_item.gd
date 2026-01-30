class_name ItemData extends Resource 
enum itemTypes {consumable,weapon,gloves,boots,cloak,hat,keyItem,pin}

@export var itemName:String
@export var itemIcon:Texture2D
@export_multiline var itemDescription:String
# @export var ammount:int = 1 #note this only really applies to consumables
# @export_enum("consumable","weapon","gloves","boots","cloak","hat","key item","pin") var itemType:String
@export var itemType:itemTypes
@export var itemScene:PackedScene #this just refers to the scene associated with the item
@export_range(1,999,1,"hide_slider","or_greater") var stackLimit:int
