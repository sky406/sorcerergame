extends Control
@onready var attributes = $"../attributes"
@onready var hpbar = $hp
@onready var hpval = $"hp/debug hp"


# Called when the node enters the scene tree for the first time.
func _ready():
	hpbar.max_value = attributes.get_attribute("constitution")
	hpbar.value = attributes.hp
	hpval.text = str(attributes.hp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_attributes_attribute_changed(newattr):
	print("recalculating hp")
	hpbar.max_value = attributes.get_attribute("constitution")
	hpbar.value = attributes.hp
	hpval.text = str(attributes.hp)

