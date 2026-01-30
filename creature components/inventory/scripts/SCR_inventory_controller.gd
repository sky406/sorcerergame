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

var container:Dictionary[int,ItemContainer] # the dictionary is int teh format {item:ItemData,count:int}
var slotsFilled = 0 

#region signals
signal itemAdded(item:ItemData,count:int)
signal itemRemoved(item:ItemData,count:int)
signal inventoryFull()
signal itemDenied(item:ItemData,count:int)
signal overflow(item:ItemData,count:int)
# ):
#endregion

#region initialize
func _ready() -> void:
	# ):
		initializeContainer()

func initializeContainer() -> void:
	for i in range(capacity):
		container[i] = ItemContainer.new()

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
	if position > capacity:
		position = capacity

	match item.itemType in allowedTypes:
		true:
			if position == -1:
				var existingSlot = findSame(item)
				var emptySlot = findEmpty()

				if existingSlot != -1:
					var slotOverflow = container[existingSlot].add(count) 
					# didn't want to shadow the signal 
					itemAdded.emit(item,abs(slotOverflow-count))
					
					if slotOverflow >0 and emptySlot != -1:
						insert(item,slotOverflow,emptySlot)
					
					elif slotOverflow >0 and emptySlot == -1:
						overflow.emit(item,slotOverflow)
					else:
						return
					# if slotOverflow >0 and emptySlot!=-1:
					# 	container[emptySlot] = ItemContainer.new(item,slotOverflow)
					# elif slotOverflow >0 and emptySlot == -1:
					# 	itemAdded.emit(item,count-slotOverflow)
					# 	overflow.emit(item,slotOverflow)
					# else:
				elif emptySlot !=-1:
					insert(item,count,emptySlot)
				
				else:
					itemDenied.emit(item,count)
			else:
				if container[position].item ==ItemContainer.empty:
					var replacedItem = container[position].replace(item,count)
					var itemOverflow = replacedItem[2]
					if itemOverflow:
						overflow.emit(item,itemOverflow)

				else:
					var replacedItem = container[position].replace(item,count)
					var itemOverflow = replacedItem[2]
					var oldItem = replacedItem[0]
					var oldCount = replacedItem[1]
					if itemOverflow:
						overflow.emit(item,itemOverflow)
					itemRemoved.emit(oldItem,oldCount)
					itemAdded.emit(item,count-itemOverflow)


		false:
			itemDenied.emit(item,count)


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
	if findSame(item) == -1:
		return 0

	else:
		var count = 0
		for i in container.keys():
			if container[i].item == item:
				count += container[i].count
		return count


func findEmpty() -> int:
	# ):
	''' returns the index of the nearest empty slot '''
	return container.find_key(ItemContainer.new())

func findSame(item:ItemData) -> int:
	# ):
	for slot in container.keys():
		if container[slot].item == item:
			return slot 
	return -1
				

#endregion
