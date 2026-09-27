@tool
extends Node
class_name ProjSpawner
#region exports
@export_category("spawnSettings")

## how much the projectile launch deviates horizontally
@export_range(0,90,0.1,"suffix:degrees") var H_deviation:float = 0.0

## how much the projectile launch deviates vertically
@export_range(0,90,0.1,"suffix:degrees") var v_deviation:float = 0.0


# TODO find a way to modify the deviation probabbly implementi it to weapons
@export var spawnLocation:Marker3D:
	set(value):
		spawnLocation = value
		update_configuration_warnings()

@export var continuousSpawn:bool = false


#region configuration code

func _get_configuration_warnings() -> PackedStringArray:
	# ):
	var warning:PackedStringArray=[]

	if not spawnLocation:
		warning.append("Spawn location has not been defined. node will not function properly")
	return warning
#endregion


func launchProjectile(projectile:Projectile,direction:Vector3,force:float) -> void:
	# ):
	direction += Global.dtoV3(randf()*H_deviation,randf()*v_deviation)
	print(direction)
	var proj = projectile.generateProjectile()
	proj.global_position = spawnLocation.global_position
	var tree = get_tree()
	# var root = tree.root
	tree.root.add_child(proj)

	var impulse:Vector3 = direction * force
	proj.apply_impulse(impulse)
