extends CharacterBody3D
class_name PlayerController 
#region export variables
@export_category("attributes")
@export_group("core attributes")
@export_range(1,20,1,"or_greater","hide_slider") var strength:float
@export_range(1,20,1,"or_greater","hide_slider") var dexterity:float
@export_range(1,20,1,"or_greater","hide_slider") var constitution:float
@export_range(1,20,1,"or_greater","hide_slider") var inteligence:float
@export_range(1,20,1,"or_greater","hide_slider") var wisdom:float
@export_range(1,20,1,"or_greater","hide_slider") var charisma:float
@export_group("meta attributes")
@export_range(1,100,1,"or_greater","hide_slider") var level:int

@export_category("movement")
@export_range(0,100,5,"or_greater","suffix:feet per round") var baseSpeed:float = 30
@export var runMultiplier:float = 2 #think of this as 30 feet in 6 seconds for programming reasons 
@export var jumpVelocity:float = 20 

@export_category("camera")
@export_range(10,90,0.1,"or_less") var horizontalLookSensitivity:float = 15.0
@export_range(10,90,0.1,"or_less") var verticalLookSensitivity:float = 15.0
@export_range(-90,0,0.1) var minLookAngle:float = -90
@export_range(0,90.1,0.1) var maxLookAngle:float = 90

@export_category("physics")
@export var gravity:float = ProjectSettings.get_setting('physics/3d/default_gravity')
#endregion

#region other player vars
@onready var inputs = $inputs
@onready var charBody = $claire_pawn
@onready var camOrbit = $cameraOrbit
@onready var lookDir = $lookDirection
@onready var attributes = $attributes

#endregion

var mouseLocked:bool = true
var currentSpeed = baseSpeed

signal effect_Failed(effect:Effect) #):
signal effect_Applied(effect:Effect)



func _ready():
	# lock mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	initializeAttributes()


func _process(delta: float):
	rotateCam(delta)
	currentSpeed = attributes.getAttributeValue("speed")
	
func _physics_process(delta: float):
	fall(delta)
	move()


# movement functions 
func move(isAming=false):
	var inputDir = inputs.inputDir
	var direction = (transform.basis * Vector3(inputDir.x,0,inputDir.y)).normalized()
	var moveSpeed = Global.convertSpeedtometers(currentSpeed)
	if inputs.isRunning:
		moveSpeed *= runMultiplier
	# TODO remember to add a dash speed

	if direction:
		# charBody.look_at(position+direction) #look in the direaction of the of movement 
		lookDir.look_at(position+direction) #point in the intended direction
		if !isAming:
			charBody.rotation.y = lerp_angle(charBody.rotation.y,lookDir.rotation.y,0.3)

		# TODO fix this to rotate smothely 

		velocity.x = direction.x * moveSpeed
		velocity.z = direction.z * moveSpeed
	else:
		velocity.x = lerp(velocity.x,0.0,0.9)
		velocity.z = lerp(velocity.z,0.0,0.9)
	if inputs.jump and is_on_floor():
		velocity.y = jumpVelocity
	move_and_slide()

func fall(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta


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

func initializeAttributes():
	var attribs:Dictionary[String,Attribute] = {
	# core attribs 
		"strength":Attribute.new(strength),
		"dexterity":Attribute.new(dexterity),
		"constitution":Attribute.new(constitution),
		"inteligence":Attribute.new(inteligence),
		"wisdom":Attribute.new(wisdom),
		"charisma":Attribute.new(charisma),
	# meta attribs
		"level":Attribute.new(level,false,20,true),
	
	# movement attributes
		"speed":Attribute.new(baseSpeed,false,999),
	}
	attributes._setAttributes(attribs)

func applyEffect(effect:Effect):
	var effectApplied = attributes.applyEffect(effect)
	if effectApplied:
		effect_Applied.emit(effect)
	else:
		effect_Failed.emit(effect)
