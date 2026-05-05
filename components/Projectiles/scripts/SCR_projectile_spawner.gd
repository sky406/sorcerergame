@tool
extends Node
class_name ProjSpawner
@export_category("spawnSettings")
@export var deviation:float = 0.0
@export var spawnLocation:NodePath:
	set(value):
		spawnLocation = value
		update_configuration_warnings()

@export var continuousSpawn:bool = false

# @export var preview:bool:
# 	set(value):
# 		if value:
# 			spawnProjectile()


func _get_configuration_warnings() -> PackedStringArray:
	# ):
	var warning:PackedStringArray=[]

	if not spawnLocation:
		warning.append("Spawn Location is not set\nA spawn location is required for this node to work")
	
	return warning

func spawnProjectile(projectile:Projectile):
	pass

func launchProjectile(direction:Vector3):
	pass
