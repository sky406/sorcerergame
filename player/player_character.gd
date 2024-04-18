extends CharacterBody3D
@onready var camcontrol = $cameraOrbit
@onready var meshcontrol = $meshControl
@export var speed:float = 10
@export var acceleration:float = 5
@export var dash_speed:float = 60
@export var sprint_speed:float = 36
@export var jump_vel:float = 20

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouseDelta:Vector2 = Vector2.ZERO
@export var lookSensitivity:float = 15.0
var horizontallook:float = 5
var verticallook:float = 15
var current_speed = speed

func _ready():
	#lock mouse to screen 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

func _process(delta):
	# track mouse movement for camera control
	var rot = Vector3(mouseDelta.y,mouseDelta.x,0)*delta*lookSensitivity
	rotatecam(rot)
	mouseDelta = Vector2.ZERO
	# 
	print(angle_to_angle(meshcontrol.rotation_degrees.y,rotation_degrees.y))


# cam control (might use it  for other thigns so i'm kinda isolating it)
@export var maxLookAngle:float = 90
@export var minLookAngle:float = -90

func rotatecam(rot,lockedvertical=true):
	rotation_degrees.y -= rot.y
	camcontrol.rotation_degrees.x -= rot.x
	if lockedvertical:
		camcontrol.rotation_degrees.x = clamp(camcontrol.rotation_degrees.x,minLookAngle,maxLookAngle)
	meshcontrol.rotation_degrees.y += rot.y
	

# ################################

func _physics_process(delta):
	# print(getSpeed())
	# debug player speed, TODO remove release
	
	# gravity 
	if not is_on_floor():
		velocity.y -= gravity * delta	
	# jumping 
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_vel
	
	move()

func dash():
	pass

func getSpeed():
	var vel = get_real_velocity()
	var horizontal_speed:float = sqrt(pow(vel.x,2)+pow(vel.z,2))
	var totalspeed = sqrt(pow(vel.y,2)+pow(horizontal_speed,2))
	return snapped(totalspeed,0.01)
	
func move():
	var input_dir = Input.get_vector("strafeLeft","strafeRight","moveForward","moveBackward")
	var direction = (transform.basis * Vector3(input_dir.x,0,input_dir.y)).normalized()
	if Input.is_action_pressed("dash"):
		current_speed = sprint_speed
	else:
		current_speed = speed
	
	if direction:
		### faceing movement direction (when not aiming)
		meshcontrol.look_at(position+direction)
		# print(meshcontrol.rotation_degrees)
		print(meshcontrol.position+direction)
		print(position+direction)
		####
			
		####
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		# ironically this sorta works
		velocity.x = lerp(velocity.x,0.0,0.1)
		velocity.z = lerp(velocity.z,0.0,0.1)
	move_and_slide()

func correctAngle(rot):
	var angle:float = abs(fmod(rot,360))
	# print(angle)
	return angle
func angle_to_angle(from,to):
	# returns the closest angle to turn to for rotation
	var corrected_from = correctAngle(from)
	var corrected_to = correctAngle(to)
	var difference = corrected_to-corrected_from
	print("from: "+str(corrected_from)+" to: "+str(corrected_to)+" diff "+str(difference))
	if difference > 180 or difference < -180:
		
		pass
	# TODO make the player model roatate towards the direction it's moving
	
