extends MarginContainer
class_name InteractLabel
@export var InteractText:String = "Interact"
@export var iconImage:Texture2D
@onready var icon:TextureRect = $HBoxContainer/TextureRect
@onready var label:Label = $HBoxContainer/Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#icon.texture = iconImage
	#label.text = InteractText

func OutOfRange():
	queue_free()
