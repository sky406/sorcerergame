extends Node3D
var numberspewed = 0
@onready var spreadslider = $"../Control/spread slider"
@onready var gravslider = $"../Control/grav slider"
@onready var lanchslider = $"../Control/launch slider"
@onready var lifeslider = $"../Control/life slider"
@onready var intervalslider = $"../Control/interval slider"
@onready var spewtimer = $"../Timer"
@onready var intervallabel = $"../Control/VBoxContainer/interval val"
@onready var lifetimelabel = $"../Control/VBoxContainer/lifetime val"
@onready var launchpowerlabel = $"../Control/VBoxContainer/launchpower val"
@onready var gravitylabel = $"../Control/VBoxContainer/gravity val"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var intervaltext = "wait time: %s"
	intervallabel.text = intervaltext % spewtimer.wait_time
	
	var lifetimetext = "animationspeed: %s"
	lifetimelabel.text = lifetimetext % lifeslider.value
	
	var launchpowertext = "launchpower: %s"
	launchpowerlabel.text = launchpowertext % lanchslider.value
	
	var gravtext = "gravity: %s"
	gravitylabel.text = gravtext % gravslider.value
	
func _on_timer_timeout():
	numberspewed+=1
	var launchval = lanchslider.value
	var gravval = gravslider.value
	var spreadval = spreadslider.value
	var speedval = lifeslider.value
	DisplayDamage.display(
		str(120),
		position,
		launchval,
		Color(1,1,1),
		speedval,
		spreadval,
		spreadval,
		gravval,
		true,
		DisplayDamage.rgbTocol(255,58,61),
		"little subtext"
	)
#TODO give more control over the spew of numbers


func _on_interval_slider_drag_ended(value_changed):
	if value_changed:
		spewtimer.wait_time = intervalslider.value
