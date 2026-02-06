extends Node3D
class_name InteractionManager

@onready var player = get_tree().get_first_node_in_group("player")


signal updateAreas(areas:Array[Interactable])


var active_areas:Array[Interactable] = []
var can_interact = true

func register_area(area:Interactable):
	active_areas.push_back(area)

func unregister_area(area:Interactable):
	var index = active_areas.find(area)
	if index!=-1:
		active_areas.remove_at(index)

func _process(delta: float):
	if active_areas.size() > 0 and can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		#updateAreas.emit(active_areas)
		# this part simply sorts the areas in order of closest 
	
	


func _sort_by_distance_to_player(area1,area2):
	var area1_to_player = player.global_position.distance_to(area1)
	var area2_to_player = player.global_position.distance_to(area2)
	return area1_to_player < area2_to_player

func _input(event:InputEvent):
	if event.is_action_pressed("interact") and can_interact:
		can_interact = false
		await active_areas[0].InteractAction.call
