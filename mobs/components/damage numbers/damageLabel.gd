extends RigidBody3D
@onready var lifeclock = $Timer
@onready var Damlabel = $"SubViewport/Node3D/damage number"
@onready var critlabel = $SubViewport/Node3D/crittext
@onready var sublabel = $"SubViewport/Node3D/sub text"
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
# Called when the node enters the scene tree for the first time.
func _ready():
	#ap.play("up and vanish")
	lifeclock.wait_time = lifetime
	lifeclock.start()
	Damlabel.text = displaytext
	Damlabel.modulate = col
	Damlabel.modulate.a = 0
	Damlabel.outline_modulate.a = 0
	apply_impulse(Vector3(xspeed,yspeed,zspeed))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	while Damlabel.modulate.a < 255:
		Damlabel.modulate.a+=fadeinspeed
		Damlabel.outline_modulate.a+=fadeinspeed
		Damlabel.modulate.a = clamp(Damlabel.modulate.a,0,255)
	if Damlabel.modulate.a >=255:
		fadein = false
	if timeup:
		Damlabel.modulate.a-=fadeinspeed
		Damlabel.outline_modulate.a-=fadeinspeed
		Damlabel.modulate.a = clamp(Damlabel.modulate.a,0,255)
	if Damlabel.modulate.a <=0:
		queue_free()

func _physics_process(delta):
	#gravity
	apply_force(Vector3(0,dropspeed,0))
	

func _on_timer_timeout():
	timeup = true

#TODO fix the fade ins of the labels
