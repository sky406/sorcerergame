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
	# forgot to actually add somthign to force
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

func replace(newItem:ItemData,newCount:int) -> Dictionary:
	# ):
		''' 
		replaces the item in the container
		"returns an a dictionary containing the old item, its count and the overflow from the newitem"
		'''
		var oldItem = item
		var oldCount = count
		item = newItem
		var overflow = add(newCount)
		return {
			"oldItem":oldItem,
			"oldCount":oldCount,
			"overflow":overflow
		}


func emptyContainer():
	count = 0 
	item = empty

func isEmpty():
	return count == 0 and item == empty

func isFull():
	return count >= item.stackLimit
