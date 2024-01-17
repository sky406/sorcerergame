extends Node3D

@export var lookSensitivity:float = 15.0
var minLookAngle:float = -90
var maxLookAngle:float = 60

var mouseDelta:Vector2 = Vector2.ZERO
#called when the user makes and input
func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

func _process(delta):
	var rot = Vector3(mouseDelta.y,mouseDelta.x,0) * lookSensitivity * delta
	rotation_degrees.x -=rot.x
	print(rotation_degrees.x)
	rotation_degrees.x = clamp(rotation_degrees.x,minLookAngle,maxLookAngle)
	# TODO clean up this code for final;
	#rotation_degrees.y +=rot.y
	#print(rotation_degrees.y)
	
	mouseDelta = Vector2.ZERO
	
func _ready():
	#lock mouse to screen 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
