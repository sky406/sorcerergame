extends Node2D
@export var testAttrib:Attribute
@export var testEfect:Effect
@export var attribs:Array[Attribute]= [
	Attribute.new("t1"),
	Attribute.new("t2")
]
@export var testEffect2:Effect
@export var testEffect3:Effect
@onready var valueLabel = $"Control/VBoxContainer/testattribute value"
@onready var duoLabel = $Control/VBoxContainer/multiattrib
@onready var duoLabel2 = $Control/VBoxContainer/multiattrib2

func _process(delta: float) -> void:
	var layouttext = "attribute value %s"
	var layouttextformatted = layouttext % [testAttrib.total()]
	valueLabel.text = layouttextformatted
	
	duoLabel.text = "attribute value %s" % [attribs[0].total()]
	duoLabel2.text = "atribute 2 value %s" %[attribs[1].total()]
	print(testAttrib.accepted)
	
func _on_button_pressed() -> void:
	testAttrib.addEffect(testEfect)
	print(testAttrib.effects_applied)
	print(testAttrib.multiplier)
	
func _on_button_2_pressed() -> void:
	testAttrib.removeEffect(testEfect)
	print(testAttrib.effects_applied)
	print(testAttrib.multiplier)

func _on_addattrib_1_pressed() -> void:
	for attrib in attribs:
		print("attempt to add %s to %s: %s"%[testEffect2.effectName,attrib.name,attrib.addEffect(testEffect2)])

func _on_addattrib_2_pressed() -> void:
	for attrib in attribs:
		print("attempt to add %s to %s: %s"%[testEffect3.effectName,attrib.name,attrib.addEffect(testEffect3)])
		

func _on_removeattrib_1_pressed() -> void:
	for attrib in attribs:
		print("attempt to remove %s from %s: %s"%[testEffect2.effectName,attrib.name,attrib.removeEffect(testEffect2)])

func _on_removeattrib_2_pressed() -> void:
	for attrib in attribs:
		print("attempt to remove %s from %s: %s"%[testEffect3.effectName,attrib.name,attrib.removeEffect(testEffect3)])
