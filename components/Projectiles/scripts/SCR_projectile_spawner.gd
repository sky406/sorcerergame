@tool
extends Node
class_name ProjSpawner
#region exports
@export_category("spawnSettings")
@export var deviation:float = 0.0
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


func launchProjectile(projectile:Projectile,direction:Vector3,impulse:Vector3) -> void:
	# ):
	var proj = projectile.generateProjectile()
	proj.global_posistion = spawnLocation.global_position
	
	var error = get_tree().add_child(proj)
	if error != OK:
		push_error("couldn't add projectile to tree")
	else:
		proj.apply_impulse(impulse)

func _ready() -> void:
	pass
