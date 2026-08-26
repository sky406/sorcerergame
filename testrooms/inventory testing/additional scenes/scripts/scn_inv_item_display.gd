extends Control
class_name test_Inv_display
@onready var nameLabel = $HBoxContainer/itemName
@onready var countLabel = $HBoxContainer/itemCount
@onready var IconImage = $HBoxContainer/MarginContainer/itemIcon
@onready var slotLabel = $HBoxContainer/itemslot
#var iconTexture:Texture2D = load("res://assets/textures/placeholder blobie.png")
#var itemName:String = "noName"
#var itemCount:int = 0
var container:ItemContainer = ItemContainer.new()
var itemslot = 0

signal countChanged(newCount:int)
signal containerChanged()
#TODO make the ready make a blank inventory
func _ready() -> void:
	item_update()
	

func kill() -> void:
	queue_free()

func updatecontainer(item:ItemContainer):
	container = item
	containerChanged.emit()

func item_update() -> void:
	var item = container.item
	nameLabel.text =  item.itemName
	countLabel.text = str(container.count)
	IconImage.texture = item.itemIcon
	slotLabel.text = str(itemslot)
	
