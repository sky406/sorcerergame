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
	var sprint_format
	
	# gravity 
	if not is_on_floor():
		velocity.y -= gravity * delta	
	# jumping 
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_vel
	
	move()

func dash():
	var dash_speed = 60

func getSpeed():
	var velocity = get_real_velocity()
	var horizontal_speed:float = sqrt(pow(velocity.x,2)+pow(velocity.z,2))
	var totalspeed = sqrt(pow(velocity.y,2)+pow(horizontal_speed,2))
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
		####
		while Input.is_action_pressed("dash"):
			pass
			
		####
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		# ironically this sorta works
		velocity.x = lerp(velocity.x,0.0,0.1)
		velocity.z = lerp(velocity.z,0.0,0.1)
	move_and_slide()
