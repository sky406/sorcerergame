extends Resource
class_name Inventory
var container:Array[InvItem]
@export var limit:int = -1
# setting the limit to -1 would simply make the limit infinite
signal cannotAddItem(item:InvItem,reason:String)
signal inventoryFull()
signal overIndex()
func addItem(item:InvItem):
#	for now ignore item sorting because the equipment slots will just be simple gui
	if container.size() == limit:
		print("inventory full")
		cannotAddItem.emit(item,"inventory full")
		inventoryFull.emit()
	else:
		container.append(item)
func removeItem(slot:int):
	if slot > container.size():
		push_error("how did you manage this")
	else:
		return container[slot]
# considering how this is writtine i might end up scrapping it, with my inventory rules

func addToSlot(item:InvItem,slot):
	if slot >= container.size():
		container.insert(slot,item)
	else:
		addItem(item)
func empty():
	var contents = container
	container = []
	return contents
