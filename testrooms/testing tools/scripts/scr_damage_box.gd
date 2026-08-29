extends Node3D
@onready var colisionArea = $Area3D

## how much damage to deal to the player on colision 
@export var damageAmmount:float = 2
@export var damageType = "slashing"

func _ready() -> void:
	colisionArea.connect("body_entered",damagePlayer)
	
func damagePlayer(body):
	print("applying damage")
	var player:PlayerController = body
	player.damage(damageAmmount,damageType)
