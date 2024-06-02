extends Control
@onready var attributes = $"../attributes"
@onready var hpbar = $hp
@onready var hpval = $"hp/debug hp"


# Called when the node enters the scene tree for the first time.
func _ready():
	hpbar.max_value = attributes.maxhp
	hpbar.value = attributes.hp
	hpval.text = str(attributes.hp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
