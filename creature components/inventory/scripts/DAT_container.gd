extends Object
class_name ItemContainer
const empty:ItemData = preload("res://creature components/inventory/res_null_item.tres")
var count:int
var item:ItemData = empty

func _init(
		invItem:ItemData=empty,
		itemCount:int = 0
	) -> void:
	# ):
	item = invItem
	count = itemCount
	count = clamp(count,0,invItem.stackLimit)

func add(ammount:int=1,force:bool=false) -> int:
	# ):
	'''  
	adds to the item count, 
	returns any item overflow(the ammount that cant fit)
	'''
	count+=ammount
	if count > item.stackLimit and force==false:
		var overflow = count - item.stackLimit
		count = item.stackLimit
		return overflow
	else:
		return 0 

func remove(ammount:int=1) -> int:
	# ):
	''' returns the ammount taken out of the container '''
	if ammount >= count:
		count = 0
		item = empty
		return count
	else:
		count -= ammount	
		return ammount

func replace(newItem:ItemData,newCount:int) -> Array:
	# ):
		''' 
		replaces the item in the container
		returns an array containing the original item, the item count and the excess count of the new item in that order
		'''
		var oldItem:ItemData = item
		var oldCount:int = count
		var overflow:int
		item = newItem
		count = newCount
		if count >= item.stackLimit:
			overflow = count-item.stackLimit
			count = item.stackLimit
		return [oldItem,oldCount,overflow]



func emptyContainer():
	count = 0 
	item = empty
