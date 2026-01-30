extends Node3D
@onready var slot1 = $Control/EquimentSlot
@onready var slot2 = $Control/EquimentSlot2
@export var testitem1:ItemData
@export var testitem2:ItemData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#functions for button 1, just to keep everythig in the same script
func _on_insert_a_pressed() -> void:
	slot1.addItem(testitem1)

func _on_insert_b_pressed() -> void:
	slot1.addItem(testitem2)

func _on_swap_current_pressed() -> void:
	if slot1.slotData.data.itemName == testitem1.itemName:
		slot1.replaceItem(testitem2)
	else:
		slot1.replaceItem(testitem1)

func _on_empty_pressed() -> void:
	print("emtying")
	slot1.empty()


func _on_equiment_slot_insert_fail(item: ItemData) -> void:
	print("slot insert fail")
