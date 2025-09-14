extends Node
@onready var effectorColider1 = $effectcollision
@export var testeffect1:effectDat
# apply  a basic effect to the player 

func applyEffect1(body:Node3D):
	var player:PlayerController = body
	player.attributes._applyEffect(testeffect1)

func _ready() -> void:
	effectorColider1.onCollide = applyEffect1