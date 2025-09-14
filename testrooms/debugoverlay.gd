extends Control
@onready var container = $VBoxContainer
@onready var player = $"../player_character"
var strength:Label
var dex:Label
var con:Label
var intel:Label
var wis:Label
var char:Label
var attributes = null

func _ready():
	attributes = player.attributes
	call_deferred("add_child",strength)
	call_deferred("add_child",dex)
	call_deferred("add_child",con)
	call_deferred("add_child",intel)
	call_deferred("add_child",wis)
	call_deferred("add_child",char)

func _process(delta: float):
	pass
# func get
