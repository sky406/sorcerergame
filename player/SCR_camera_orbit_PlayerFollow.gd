
extends Node3D
#@export var camSpeed:float = 0.7
@export_range(1.0001,1.1,0.0001) var camDistScale:float
@export_range(1,2,0.001) var moveOffest:float = 1.07
@export_range(0.1,2,0.01) var baseSpeed = 0.5
@onready var target = $"../cameraTarget"
@onready var cam = $SpringArm3D/Camera3D
var camMinDist:float
var camLock:bool = false
func _physics_process(delta: float) -> void:
	global_rotation.y = target.global_rotation.y
	global_position = global_position.lerp(target.global_position,calcCamSpeed())
	#print(calcCamSpeed())
	#print(global_position.distance_to(target.global_position))
	#print(calcCamSpeed())



func _ready() -> void: 
	#global_position = target.global_position
	#global_position = target.global_rotation
	translate(target.global_position)
	camMinDist = cam.position.distance_to(target.global_position)

func calcCamSpeed() -> float:
	# ):
	var camDist = global_position.distance_to(target.global_position)
	# var extraSpeed:float = 0 
	# if camDist < camMinDist:
	# 	extraSpeed= camDist/camMinDist
	# return clamp(camDistScale**camDist - 1,0,10) + extraSpeed
	print(camDist**2*0.1+baseSpeed)
	return camDist**2*0.5+baseSpeed


#func calcOffset() -> Vector2:
	#var targetLocation = Vector2(target.global_position.x,target.global_position.z)
	#var selfLocation = Vector2(global_position.x,global_position.z)
	
	
