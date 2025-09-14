extends RigidBody3D
class_name DamageLabel
@onready var animp = $AnimationPlayer
@onready var Damlabel = $"SubViewport/Node3D/damage number"
@onready var critlabel = $SubViewport/Node3D/crittext
@onready var sublabel = $"SubViewport/Node3D/sub text"
@onready var sprite = $Sprite3D
@export var yspeed = 1
@export var xspeed= 0
@export var zspeed = 0
@export var col:Color = Color(1,1,1)
var dropspeed = 30
var displaytext = "nottext"
var criticaltext = ""
var critcol:Color = Color(1,1,1)
var subtext = ""
var subcol:Color = Color(1,1,1)
var animspeed = 1.0

# func new(
# 	Displaytext:String=displaytext,
# 	Col:Color = col,
# 	Criticaltext:
# ):
# 	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	animp.speed_scale = animspeed
	sprite.visible = true
	animp.play("fade in and out ")
	Damlabel.text = displaytext
	Damlabel.modulate = col
	critlabel.text = criticaltext
	critlabel.modulate = critcol
	sublabel.text = subtext
	sublabel.modulate = subcol
	apply_impulse(Vector3(xspeed,yspeed,zspeed))
	# TODO MAKE THE TEXT FADE PROPERLY ALSO FIND OUT IF YOU CAN USE RENDER LAYERS TO MAKE THE NUMBERS APPEAR ABOVE ENEMIES BUT NOT ENVINRONMENT AND THE PLAYER

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		pass
	# change this to work with the animation player
func _physics_process(delta):
	#gravity
	apply_force(Vector3(0,dropspeed,0))
	
func _kill_self():
	queue_free()
	

#TODO chage the way the damage number pops in to something eyecating but not in motion .
# even try to make the text pop iun 
