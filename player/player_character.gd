extends CharacterBody3D

var speed = 10
const jump_vel = 4.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_delta:Vector2 = Vector2.ZERO
@export var lookSensitivity:float = 15.0

func _process(delta):
	#get_node("playermesh").rotation_degrees.y = get_node("cameraOrbit").rotation_degrees.y
	# make the body slowly try to match the rotation 
	#might want to changes these later who knows
	#var mesh_rotationY:float = get_node("playermesh").rotation_degrees.y
	#var cam_rotationY:float = get_node("cameraOrbit").rotation_degrees.y
	#
	#var rotatespeed:float = 60
	#
	#if(mesh_rotationY != cam_rotationY):
		#mesh_rotationY = move_toward(mesh_rotationY,cam_rotationY,rotatespeed)
		#
	#get_node("playermesh").rotation_degrees.y = mesh_rotationY
	# camera movement
	var rot = Vector3(mouse_delta.y,mouse_delta.x,0) * lookSensitivity * delta
	pass
	

func _physics_process(delta):
	
		#pass
	# gravity 
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# jumping 
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_vel
	
	# moving inputs and all that 
	var input_dir = Input.get_vector("strafeLeft","strafeRight","moveForward","moveBackward")
	var direction = (transform.basis * Vector3(input_dir.x,0,input_dir.y)).normalized() # note to self this may be redundant so caheck later
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x,0,speed)
		velocity.z = move_toward(velocity.x,0,speed)
	
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
