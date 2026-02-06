extends Resource
class_name equipSlot
enum Type{consumable,weapon,gloves,cloak,pin}
@export var type:Type
@export var limit:int
var container:Dictionary
#statically typed dictionaries are not functioning in 4.3 for now 😢

func equipItem(item:PackedScene,slot:int):
	if container.size()<limit:
		if slot == null:
			var emptySlots = getEmpty()
			if emptySlots != []:
				container[emptySlots[0]] = item
			else:
				return
		#time to  test
		
func getEmpty()->Array:
	var emptyslots =[]
	for i in container.keys():
		if container[i] == null:
			emptyslots.append(i)
	return emptyslots
