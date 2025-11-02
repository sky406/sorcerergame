extends CharacterBody3D
class_name PlayerController 

@export_category("attributes")
@export_group("core attributes")
@export_range(1,20,1,"or_greater","hide_slider") var strength:int
@export_range(1,20,1,"or_greater","hide_slider") var dexterity:int
@export_range(1,20,1,"or_greater","hide_slider") var constitution:int
@export_range(1,20,1,"or_greater","hide_slider") var inteligence:int
@export_range(1,20,1,"or_greater","hide_slider") var wisdom:int
@export_range(1,20,1,"or_greater","hide_slider") var charisma:int
@export_group("meta attributes")
@export_range(1,100,1,"or_greater","hide_slider") var level:int

@export_category("movement")
@export_range(1,100,1,"or_greater","suffix:feet per round") var baseSpeed:float = 30
@export var runMultiplier:float = 2 #thing of this as 30 feet in 6 seconds for programming reasons 
# TODO add the function to apply all the settings to the children nodes, 
# focus on movement first
@export var jumpVelocity:float = 20 

@export_category("camera")
@export_range(10,90,0.1,"or_less") var horizontalLookSensitivity:float = 15.0
@export_range(10,90,0.1,"or_less") var verticalLookSensitivity:float = 15.0
@export_range(-90,0.1,90) var minLookAngle = -90
@export_range(-90,0.1,180) var maxLookAngle = 90

@export_category("physics")
@export var gravity:float = ProjectSettings.get_setting('physics/3d/default_gravity')


@onready var inputs = $inputs
@onready var charBody = $claire_pawn
@onready var camOrbit = $cameraOrbit
@onready var lookDir = $lookDirection

var mouseLocked:bool = true

func _ready():
	# lock mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta: float):
	rotateCam(delta)
	
func _physics_process(delta: float):
	fall(delta)
	jump()
	move()


# movement functions 
func move():
	var inputDir = inputs.inputDir
	var direction = (transform.basis * Vector3(inputDir.x,0,inputDir.y)).normalized()
	var current_speed = Global.convertSpeedtometers(baseSpeed)
	print(direction)
	# TODO remember to add a dash speed

	if direction:
		# charBody.look_at(position+direction) #look in the direaction of the of movement 
		lookDir.look_at(position+direction) #point in the intended direction
		charBody.rotation.y = lerp_angle(charBody.rotation.y,lookDir.rotation.y,0.3)

		# TODO fix this to rotate smothely 

		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = lerp(velocity.x,0.0,0.9)
		velocity.z = lerp(velocity.z,0.0,0.9)
	move_and_slide()

func fall(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

func jump():
	if inputs.jump and is_on_floor():
		velocity.y = jumpVelocity

func rotateCam(delta:float,counterRotation:bool=true,lockedvertical:bool=true):
	var mouseDelta = inputs.mouseDelta
	var hlook = mouseDelta.y * horizontalLookSensitivity
	var vlook = mouseDelta.x * verticalLookSensitivity
	var camRotation = Vector3(hlook,vlook,0)*delta

	rotation_degrees.y -= camRotation.y
	camOrbit.rotation_degrees.x -= camRotation.x
	if counterRotation:
		charBody.rotation_degrees.y += camRotation.y
		# if charBody.rotation_degrees.y >= 180:
		# 	charBody.rotation_degrees.y = -180
		# elif charBody.rotation_degrees

	if lockedvertical:
		camOrbit.rotation_degrees.x = clamp(camOrbit.rotation_degrees.x,minLookAngle,maxLookAngle)


	
