extends Node
class_name Inventory
#region export variables
@export_category("properties")
@export var capacity:int  #how many items the inventory can carry
@export var limited:bool = true # if theis is checked true the inventory will never be able to extend past the set capacity 
# @export var forceOverflow:bool = false
@export_group("allowed itemtypes")
@export var allowedTypes:Array[ItemData.itemTypes]
#endregion

var container:Array[ItemContainer] # the dictionary is int teh format {item:ItemData,count:int}
var slotsFilled = 0 

#region signals
signal itemAdded(item:ItemContainer,slot:int)
signal itemRemoved(item:ItemContainer,slot:int)
signal itemSwapped(oldItem:ItemContainer,newItem:ItemContainer,slot:int)
signal inventoryFull()
signal itemDenied(item:ItemContainer)
signal overflow(item:ItemContainer)
# ):
#endregion

#region initialization

func _ready() -> void:
	# ):
		initializeContainer()

func initializeContainer() -> void:
	container.resize(capacity)
	for slot in range(container.size()):
		container[slot] = ItemContainer.new()
		print(container[slot])

#endregion

#region inventory functions
# ):
# note: do not add signals to any of these
func _setSlot(slot:int,item:ItemData):
		container[slot].emptyContainer()
		container[slot].item = item

# TODO for the overflow container change this to use force
func _addToSlot(slot:int,count:int) -> int:
		# ):
		var excessItems = container[slot].add(count)
		return excessItems

func pop(slot:int) -> ItemContainer:
	# ):
	var removedItem = container[slot]
	container[slot].emptyContainer()
	itemRemoved.emit(removedItem,slot)
	return removedItem
			
func countItem(item:ItemData) -> int:
	# ):
	var itemCount:int = 0
	for slot in Container:
		if container[slot].item == item:
			itemCount+= container[slot].count
	return itemCount

func findEmpty() -> int:
	# ):
	''' returns the index of the nearest empty slot '''
	for slot in container:
		if slot.isEmpty():
			print_debug(container.find(slot))
			return container.find(slot)
	return -1 

func findSame(item:ItemData) -> int:
	# ):
	for slot in container:
		if slot.item == item:
			print_debug(container.find(slot))
			return container.find(slot)
		else:
			print_debug("not the itme you're looking for （*゜ー゜*） it's this instead: %s"%[slot.item.itemName])
	return -1

#endregion

#region inventory controls
func put(item:ItemContainer,slot:int=-1) -> void:
	# ):
	# puts an item into a slot 
	# note to self may come back to fix this if this workd, because i realized the set slot command is -
	# kinda redundant  but that's for a future me and not for you reading this you pervert
	if slot == -1 or slot >= capacity -1:
		var existingSlot = findSame(item.item)
		print("existing slot = %s"%[existingSlot])
		var emptySlot = findEmpty()
		print("empty slot = %s"%[emptySlot])
		if existingSlot != -1:
			_addToSlot(existingSlot,item.count)
			itemAdded.emit(container[existingSlot],existingSlot)
		elif emptySlot != -1:
			_setSlot(emptySlot,item.item)
			_addToSlot(emptySlot,item.count)
			itemAdded.emit(container[emptySlot],emptySlot)
		else:
			itemDenied.emit(ItemContainer)
	else:
		if container[slot].isEmpty():
			_setSlot(slot,item.item)
			_addToSlot(slot,item.count)
			itemAdded.emit(container[slot],slot)
		else:
			var removedItem = container[slot]
			container[slot] = item
			itemSwapped.emit(removedItem,item,slot)
			




func pull(slot:int,count:int=-1) -> ItemContainer:
	# pull an an item from a slot, return empty item container if the slot is empty
	# empties the slot if the whole stack can be picked up
	# if count is -1 collects upt ot it's stack limit
	# ):
	var item:ItemData = container[slot].item
	if count == -1:
		count = item.stackLimit
		
	var ammountReturned = container[slot].remove(count)
	var removedItem = ItemContainer.new(item,ammountReturned)
	itemRemoved.emit(removedItem,slot)
	return removedItem

func pullItem(item:ItemData,count) -> ItemContainer:
	# ):
	var itemLocation = findSame(item)
	if itemLocation != -1:
		return pull(itemLocation,count)
	else:
		return ItemContainer.new()



#endregion
