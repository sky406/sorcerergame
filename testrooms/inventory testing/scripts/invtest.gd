extends Control
#region key variables
@onready var item1AddButton = $"PanelContainer/MarginContainer/VBoxContainer/add item 1"
@onready var item1RemoveButton = $"PanelContainer/MarginContainer/VBoxContainer/remove item 1"
@onready var item2AddButton = $"PanelContainer/MarginContainer/VBoxContainer/add item 2"
@onready var item2RemoveButton = $"PanelContainer/MarginContainer/VBoxContainer/remove item 2"
@onready var item1Slider = $"PanelContainer/MarginContainer/VBoxContainer/item 1 ammount"
@onready var item2Slider = $"PanelContainer/MarginContainer/VBoxContainer/item 1 ammount2"
@onready var invBox = $ScrollContainer/invDisplay
@onready var inventory = $ScnInventoryNode
const item1 = preload("res://testrooms/inventory testing/resources/test item1.tres")
const item2 = preload("res://testrooms/inventory testing/resources/test item2.tres")
const itemDisplay = preload("res://testrooms/inventory testing/additional scenes/SCN_inv_item_display.tscn")
#endregion
var filledSlots:Dictionary[int,test_Inv_display]
#region controls
func addItem1():
	inventory.insert(item1,item1Slider.value)
func removeItem1():
	inventory.remove(item1,item1Slider.value)

func addItem2():
	inventory.insert(item2,item2Slider.value)
func removeItem2():
	inventory.remove(item2,item2Slider.value)
#endregion

func onItemAdd(item: ItemData,count: int,slot: int) -> void :
	if slot in filledSlots.keys():
		filledSlots[slot].add(count)
	else:
		var newDisplay = itemDisplay.instantiate()
		newDisplay.itemName = item.itemName
		#newDisplay.itemIcon = item.itemIcon
		newDisplay.itemCount = count
		newDisplay.iconTexture = item.itemIcon
		filledSlots[slot]=newDisplay
		print_debug(filledSlots)
		itemDisplay.call_deferred("add_child",newDisplay)
func onItemRemove(item:ItemData,count:int,slot:int):
	if slot in filledSlots.keys():
		filledSlots[slot].subtract(count)
