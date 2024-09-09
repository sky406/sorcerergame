extends RigidBody3D
@onready var animp = $AnimationPlayer
@onready var lifeclock = $Timer
@onready var Damlabel = $"SubViewport/Node3D/damage number"
@onready var critlabel = $SubViewport/Node3D/crittext
@onready var sublabel = $"SubViewport/Node3D/sub text"
@onready var sprite = $Sprite3D
@export var yspeed = 1
@export var xspeed= 0
@export var zspeed = 0
@export var col:Color = Color(1,1,1)
var dropspeed = 30
@export var fadeinspeed = 30
@export var fadein:bool = true
@export var lifetime:float = 1.0
var timeup:bool = false
var displaytext = "nottext"
var criticaltext = ""
var critcol:Color = Color(1,1,1)
var subtext = ""
var subcol:Color = Color(1,1,1)
var animspeed = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	#ap.play("up and vanish")
	sprite.visible = true
	animp.play("fade in and out ")
	lifeclock.wait_time = lifetime
	lifeclock.start()
	Damlabel.text = displaytext
	Damlabel.modulate = col
	#Damlabel.modulate.a = 0
	#Damlabel.outline_modulate.a = 0
	critlabel.text = criticaltext
	critlabel.modulate = critcol
	sublabel.text = subtext
	sublabel.modulate = subcol
	apply_impulse(Vector3(xspeed,yspeed,zspeed))
	# TODO MAKE THE TEXT FADE PROPERLY ALSO FIND OUT IF YOU CAN USE RENDER LAYERS TO MAKE THE NUMBERS APPEAR ABOVE ENEMIES BUT NOT ENVINRONMENT AND THE PLAYER

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#while Damlabel.modulate.a < 255:
		#Damlabel.modulate.a+=fadeinspeed
		#Damlabel.outline_modulate.a+=fadeinspeed
		#Damlabel.modulate.a = clamp(Damlabel.modulate.a,0,255)
	#if Damlabel.modulate.a >=255:
		#fadein = false
	#if timeup:
		#Damlabel.modulate.a-=fadeinspeed
		#Damlabel.outline_modulate.a-=fadeinspeed
		#Damlabel.modulate.a = clamp(Damlabel.modulate.a,0,255)
	#if Damlabel.modulate.a <=0:
		#queue_free()
		pass
	# change this to work with the animation player
func _physics_process(delta):
	#gravity
	apply_force(Vector3(0,dropspeed,0))
	
func _kill_self():
	queue_free()
	

func _on_timer_timeout():
	timeup = true

#TODO chage the way the damage number pops in to something eyecating but not in motion .
# even try to make the text pop iun 
