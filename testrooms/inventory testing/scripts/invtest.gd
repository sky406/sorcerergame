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
var invSlots:Array[ItemContainer]
var slotCtrls:Array[test_Inv_display]
func _ready():
	invSlots = inventory.container
	for slot in invSlots:
		var slotctrl = itemDisplay.instantiate()
		slotCtrls.append(slotctrl)
		invBox.add_child(slotctrl)
	var slotcount = 1
	for slot in slotCtrls:
		slot.itemslot = slotcount
		slot.containerChanged.emit()
		slotcount+=1
		


#region controls
func addItem1():
	var itemCont = ItemContainer.new(item1,item1Slider.value)
	print_debug("item to add: %s ammount added: %s"%[itemCont.item,itemCont.count])
	inventory.put(itemCont)
func removeItem1():
	inventory.pullItem(item1,item1Slider.value)

func addItem2():
	var itemCont = ItemContainer.new(item2,item2Slider.value)
	print_debug("item to add: %s ammount added: %s"%[itemCont.item,itemCont.count])
	inventory.put(itemCont)
func removeItem2():
	inventory.pullItem(item2,item2Slider.value)
#endregion
#note to self, these don't use the item parameter but instead grabs them from the cojntianer using the slot 
func onItemAdd(item:ItemContainer,slot: int) -> void :
	var changedItem = inventory.container[slot]
	slotCtrls[slot].updatecontainer(changedItem)
	#print_debug(slotCtrls)
	

func onItemRemove(item:ItemContainer,slot:int) -> void:
	var changedItem = inventory.container[slot]
	slotCtrls[slot].updatecontainer(changedItem)
	#print_debug(slotCtrls)
