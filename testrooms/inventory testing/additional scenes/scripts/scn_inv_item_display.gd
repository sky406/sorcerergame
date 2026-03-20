extends Control
class_name test_Inv_display
@onready var nameLabel = $AspectRatioContainer/HBoxContainer/itemName
@onready var countLabel = $AspectRatioContainer/HBoxContainer/itemCount
@onready var IconImage = $AspectRatioContainer/HBoxContainer/MarginContainer/itemIcon
@onready var slotLabel = $AspectRatioContainer/HBoxContainer/itemslot
var iconTexture:Texture2D = load("res://assets/textures/placeholder blobie.png")
var itemName:String = "noName"
var itemCount:int = 0
var invSlot:int = 0
signal countChanged(newCount:int)

func _ready() -> void:
	IconImage.texture = iconTexture
	countLabel.text = str(itemCount)
	IconImage.texture = iconTexture
	slotLabel.text = str(invSlot)
	

func kill() -> void:
	queue_free()

func add(num:int):
	itemCount += num
	countChanged.emit(itemCount)

func subtract(num:int):
	itemCount -= num
	countChanged.emit(itemCount)

func _on_count_changed(newCount: int) -> void:
	countLabel.text = str(newCount)
