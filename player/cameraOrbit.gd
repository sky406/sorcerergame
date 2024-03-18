extends Node3D
# TODO check if there is a way to globalize looksensitivity

@export var lookSensitivity:float = 15.0
var minLookAngle:float = -90
var maxLookAngle:float = 60

var mouseDelta:Vector2 = Vector2.ZERO
#called when the user makes and input
func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

func _process(delta):
	var rot = Vector3(mouseDelta.y,mouseDelta.x,0) *delta * lookSensitivity
	rotatecam(rot)
	mouseDelta = Vector2.ZERO
	print(rotation_degrees)
	

func rotatecam(rotation):
	rotation_degrees.y -= rotation.y
	rotation_degrees.x -= rotation.x
	rotation_degrees.x = clamp(rotation_degrees.x,minLookAngle,maxLookAngle)
