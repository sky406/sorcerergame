extends Node
var isActive = true
signal enteredInteractableRange(interactable:Interactable)
signal leftInteractableRange(interactable:Interactable)
var prevInteractables:Array

var nearInteractables:Array[Interactable] = [] #this is mostly controlled by the interaction manager(i could make this simpler but i'll figure it out in a way
signal updatedInteractables(interactables:Array[Interactable]) #probs don't need to store this for no reason

# add an interactables to the list

func registerArea(area:Interactable):
	nearInteractables.push_back(area)
	nearInteractables.sort_custom(_sortByDistance)
	print(nearInteractables)
	enteredInteractableRange.emit(area)

func unregisterArea(area:Interactable):
	var index = nearInteractables.find(area)
	if index!=-1:
		nearInteractables.remove_at(index)
	leftInteractableRange.emit(area)

func _sortByDistance(area1:Interactable,area2:Interactable):
	var parentcontroller:Node3D = get_parent()
	var dist_to_area1 = parentcontroller.global_position.distance_to(area1.global_position)
	var dist_to_area2 = parentcontroller.global_position.distance_to(area2.global_position)
	return dist_to_area1 < dist_to_area2

func _process(delta: float) -> void:
	# this sorts the interactables list and emits a signal every time the list changes
	nearInteractables.sort_custom(_sortByDistance)
	
	if nearInteractables != prevInteractables:
		updatedInteractables.emit(nearInteractables)
		prevInteractables = nearInteractables
	

	
