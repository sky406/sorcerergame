extends Node2D
@export var testAttrib:Attribute
@export var testEfect:Effect

@onready var valueLabel = $"Control/VBoxContainer/testattribute value"

func _process(delta: float) -> void:
	var layouttext = "attribute value %s"
	var layouttextformatted = layouttext % [testAttrib.total()]
	valueLabel.text = layouttextformatted
	


func _on_button_pressed() -> void:
	testAttrib.addEffect(testEfect)
	print(testAttrib.effects_applied)
	print(testAttrib.multiplier)


func _on_button_2_pressed() -> void:
	testAttrib.removeEffect(testEfect)
	print(testAttrib.effects_applied)
	print(testAttrib.multiplier)
