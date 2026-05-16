extends Node
@onready var launcher = $ProjectileSpawner
@export_range(1,100,1) var impulseforce:float
const projectile = preload("res://components/Projectiles/testprojectile.tres")
func _on_timer_timeout() -> void:
	launcher.launchProjectile(projectile,Vector3(-1,0,0),impulseforce)
