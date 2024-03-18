extends CharacterBody3D
@onready var camcontrol = $cameraOrbit
@export var speed:float = 10
@export var acceleration:float = 5
@export var dash_speed:float = 60
@export var sprint_speed:float = 36
@export var jump_vel:float = 20
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_delta:Vector2 = Vector2.ZERO
@export var lookSensitivity:float = 15.0
var horizontallook:float = 5
var verticallook:float = 15
var current_speed = speed

func _ready():
	#lock mouse to screen 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print(rotation_degrees)

# func _process(delta):
	
# 	var rot = Vector3(mouse_delta.y,mouse_delta.x,0) * delta * lookSensitivity
# 	rotation_degrees.y -=rot.y
# 	rotatecameraX(rot.x)
# 	mouse_delta = Vector2.ZERO

	

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
	var direction = (transform.basis * Vector3(input_dir.x,0,input_dir.y)).normalized() # note to self this may be redundant so caheck later
	print(direction)
	# if direction:
	# 	velocity.x = direction.x * current_speed
	# 	velocity.z = direction.z * current_speed
	# else:
	# 	velocity.x = lerp(velocity.x,0.0,0.1)
	# 	velocity.z = lerp(velocity.z,0.0,0.1)
	# move_and_slide()
	var movespeed = getSpeed()
	var speedtarget = speed
	if Input.is_action_pressed("dash"):
		speedtarget = sprint_speed
	else:
		movespeed = speed
	
	if direction:
		rotation_degrees.y = camcontrol.rotation_degrees.y
		camcontrol.rotation_degrees.y = 0

		####
		while Input.is_action_pressed("dash"):
			pass
			
		####
		movespeed = move_toward(movespeed,speedtarget,acceleration)
		velocity.x = direction.x * movespeed
		velocity.z = direction.z * movespeed
	else:
		# ironically this sorta works
		movespeed = lerp(movespeed,0.0,0.1)
		velocity.x = lerp(velocity.x,0.0,0.1)
		velocity.z = lerp(velocity.z,0.0,0.1)
	move_and_slide()
