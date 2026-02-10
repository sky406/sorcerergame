extends Node
class_name InvController
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
signal itemAdded(item:ItemData,count:int,slot:int)
signal itemRemoved(item:ItemData,count:int,slot:int)
signal inventoryFull()
signal itemDenied(item:ItemData,count:int)
signal overflow(item:ItemData,count:int)
# ):
#endregion

#region initialization
func _ready() -> void:
	# ):
		initializeContainer()

func initializeContainer() -> void:
	for i in range(capacity):
		container.append(ItemContainer.new())

#endregion

#region inventory controls
func insert(item:ItemData,count:int,position:int=-1):
	''' 
	adds item into inventory
	parameters
	- item: the item data of the item added
	- count: the ammount of items
	- position: which slot it should be in
	'''
	if item.itemType not in allowedTypes:
		# end quickly if the item is not accepted
		itemDenied.emit(item,count)
		print_debug("item %$ not allowed not accepted in this inventory"%[item.itemName])
		return

	if position > capacity-1:
		position = capacity-1
	
	var existingSlots:Array = findSame(item)
	var emptySlots:Array = findEmpty()

	# the process
	# check if the item can be added
	# fill existing slots(if any is left got to next step )
	# fill empty slots(if any is left emit overflow and inventory full)
	var itemsLeft = count

	for slot in existingSlots:
		if container[slot].isFull():
			pass
		else:
			

func remove(item:ItemData,count:int) -> Array:
	#):
	'''  
	note this returns an array in this format [item:itemData,count:count]
	'''
	var itemSlot = findSame(item)
	var returnItem:ItemData = ItemContainer.empty
	var returnCount:int = 0
	if itemSlot != -1:
		returnItem.item = item
		while findSame(item) !=-1 or returnCount != count:
			itemSlot = findSame(item)
			var ammountRemoved = container[itemSlot].remove(count)
			returnCount += ammountRemoved
			itemRemoved.emit(item,ammountRemoved,itemSlot)
			if returnCount < count:
				count -= ammountRemoved
			else:
				break
		return [returnItem,returnCount]
	else:
		printerr("inventory does not have item")
		return[ItemContainer.empty,0]
			

func countItem(item:ItemData) -> int:
	# ):
	var itemCount:int = 0
	for slot in Container:
		if container[slot].item == item:
			itemCount+= container[slot].count
	return itemCount

func findEmpty() -> Array[int]:
	# ):
	''' returns the index of the nearest empty slot '''
	var emptySlots = []
	for slot in container:
		if container[slot].isEmpty():
			emptySlots.append(slot)
	return emptySlots

func findSame(item:ItemData) -> Array[int]:
	# ):
	var SameSlots = []
	for slot in container:
		if container[slot].item == item:
			SameSlots.append(slot)
	return SameSlots
				
#endregion
