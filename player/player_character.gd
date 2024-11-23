extends CharacterBody3D

#references to child nodes (like the camera and mesh) that control camera movement, character orientation, and attributes.
@onready var camcontrol = $cameraOrbit
@onready var meshcontrol = $meshControl
@onready var attributes = $attributes

#settings for how fast the player moves, dashes, sprints, and jumps.
@export var speed:float = 10
@export var acceleration:float = 5
@export var dash_speed:float = 60
@export var sprint_speed:float = 36
@export var jump_vel:float = 20
signal input(inputtype)

#Gets the gravity value from the project settings.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#Tracks how much the mouse moves each frame, which is used to rotate the camera.
var mouseDelta:Vector2 = Vector2.ZERO

#Controls how sensitive the camera is to mouse movement and limits the up/down view angle.
@export var lookSensitivity:float = 15.0
var horizontallook:float = 5
var verticallook:float = 15
var current_speed = speed

#Called when the node is added to the scene. 
#Here, the mouse is locked to the screen to keep it focused on gameplay.
func _ready():
	#lock mouse to screen 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#Tracks mouse movement, updating mouseDelta with the mouse’s movement each frame.
func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

#Runs every frame. 
#It uses mouseDelta to calculate rotation for the camera, 
#calls rotatecam() to update camera position, and then resets mouseDelta to zero.
func _process(delta):
	# track mouse movement for camera control
	var rot = Vector3(mouseDelta.y,mouseDelta.x,0)*delta*lookSensitivity
	rotatecam(rot)
	mouseDelta = Vector2.ZERO

#Cam control (might use it  for other things so i'm kinda isolating it)
#Rotates the camera based on the mouse movement. 
#It also locks the vertical rotation within a range to prevent over-rotating up/down.
@export var maxLookAngle:float = 90
@export var minLookAngle:float = -90
func rotatecam(rot,lockedvertical=true):
	rotation_degrees.y -= rot.y
	camcontrol.rotation_degrees.x -= rot.x
	if lockedvertical:
		camcontrol.rotation_degrees.x = clamp(camcontrol.rotation_degrees.x,minLookAngle,maxLookAngle)
	meshcontrol.rotation_degrees.y += rot.y
	

#Runs physics calculations each frame. Handles gravity, jumping, and movement.
func _physics_process(delta):
	#Applies gravity to the player if they’re not on the floor.
	if not is_on_floor():
		velocity.y -= gravity * delta	
		
	#Checks if the player pressed the jump button and if they’re on the floor, then applies an upward velocity.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_vel
		
	#Handles player movement based on input.
	move()

func dash():
	pass

#Calculates and returns the current speed of the player.
func getSpeed():
	var vel = get_real_velocity()
	var horizontal_speed:float = sqrt(pow(vel.x,2)+pow(vel.z,2))
	var totalspeed = sqrt(pow(vel.y,2)+pow(horizontal_speed,2))
	return snapped(totalspeed,0.01)
	
#Handles player movement based on input.
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
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		# ironically this sorta works
		velocity.x = lerp(velocity.x,0.0,0.1)
		velocity.z = lerp(velocity.z,0.0,0.1)
	move_and_slide()

# Helper functions to keep rotations between 0 and 360 degrees and calculate the shortest angle to turn for smoother rotations.
func correctAngle(rot):
	var angle:float = abs(fmod(rot,360))
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
	
