extends Node
const effect = preload("res://effects/template/effect.tscn")
const player = ("res://player/player_character.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	var eff = effect.instantiate()	
	eff.constitution = 10 
