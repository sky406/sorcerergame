extends Node
class_name EquipSlot
@export_enum("consumable","weapon","gloves","boots","cloak","hat","key item","pin") var itemType:String
@export var data:InvItem = null
signal insertFail(item:InvItem)
signal insertSuccess(item:InvItem)
signal removedItem(item:InvItem)
signal swappedItem(old:InvItem,new:InvItem)
func insert(item:InvItem):
	# this function is only for use with automatic addition to inventory,
	# probabbly might be changed later
	# it will not work if the slot is alrady taken
	if item.itemType == itemType and data == null:
		data = item
		insertSuccess.emit(item)
	else:
		insertFail.emit(item)

func remove():
	if not data == null:
		var item = data
		data = null
		removedItem.emit(item)
		return item

func replace(replacement:InvItem):
	if not data == null:
		var returning = data
		data = replacement
		swappedItem.emit(returning,replacement)
		return returning
	else:
		data = replacement
