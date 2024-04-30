extends Node3D
var numberspewed = 0
@onready var spreadslider = $"../Control/spread slider"
@onready var gravslider = $"../Control/grav slider"
@onready var lanchslider = $"../Control/launch slider"
@onready var lifeslider = $"../Control/life slider"
@onready var fadeslider = $"../Control/fadetime slider"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _on_timer_timeout():
	numberspewed+=1
	var launchval = lanchslider.value
	var garvval = gravslider.value
	var spreadval = spreadslider.value
	var lifesval = lifeslider.value
	var fadeval = fadeslider.value
	DisplayDamage.display(
		str(120),
		position,
		launchval,
		Color(1,1,1),
		lifesval,
		spreadval,
		spreadval,
		garvval,
		fadeval
	)
#TODO give more control over the spew of numbers
