extends Control
@onready var slotData = $equipData
@onready var itemName = $"slot background/VBoxContainer/name"
@onready var itemDesc = $"slot background/VBoxContainer/description"
@onready var spinner = $"SubViewport/Node3D/item spinner"
@onready var animation = $AnimationPlayer
@export var locked:bool = false
@export var spinSpeed:float = 10
@export_enum("consumable","weapon","gloves","boots","cloak","hat","key item","pin") var itemType:String
signal itemAdded(item:InvItem)
signal itemRemoved(item:InvItem)
signal insertFail(item:InvItem)
signal itemSwapped(old:InvItem,new:InvItem)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slotData.itemType = itemType
	animation.play("spin")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spinner.rotation_degrees.y+=spinSpeed

func addItem(item:InvItem):
	slotData.insert(item)

func replaceItem(item:InvItem):
	slotData.replace(item)

func empty():
	return slotData.remove()
	

func _on_equip_data_insert_success(item: InvItem) -> void:
	itemName.text = item.itemName
	itemDesc.text = item.itemDescription
	var spinningItem = item.itemScene.instantiate()
	spinner.add_child(spinningItem)
	itemAdded.emit(item)


func _on_equip_data_removed_item(item: InvItem) -> void:
	
	itemName.text = ""
	itemDesc.text = ""
	for i in spinner.get_children():
		spinner.remove_child(i)
		i.queue_free()
	itemRemoved.emit(item)
	print("item removed")

func _on_equip_data_swapped_item(old: InvItem, new: InvItem) -> void:
	#clear the dlot first
	for i in spinner.get_children():
		spinner.remove_child(i)
		i.queue_free()
	
	itemName.text = new.itemName
	itemDesc.text = new.itemDescription
	var spinningItem = new.itemScene.instantiate()
	spinner.add_child(spinningItem)
	itemSwapped.emit(old,new)


func _on_equip_data_insert_fail(item: InvItem) -> void:
	insertFail.emit(item)
	print("failed to insert")

#note to self maybe add all the slot code into the equipment slot, idk 
