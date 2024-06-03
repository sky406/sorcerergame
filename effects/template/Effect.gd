extends Node
@export var icon:Image = null
@export var effectname = "template"
@onready var lifetimer = $lifetimer
@onready var interval = $intervaltimer
@export var targetAttribute:Node = null
# main properties
var displayeffect:bool = false
var timedeffect:bool = false
var isstackbale:bool = false
var lifetime:float = 0
var overtime:Dictionary = {"active":false,"interval":0} 
var effectOn=false

signal effect_end
signal effect_added
signal effect_removed
signal effect_interval_timeout


# attributes that can be targeted
var strength = 0
var dexterity = 0 
var constitution = 0 
var inteligence = 0 
var wisdom = 0 
var charisma = 0 
var maxhp = 0
var damage_bonus = [{"dice":null,"number":0,"type":"all"}]#make a seperate dictionary for every damage type
var speed = {"number":0,"percent":0}



func _init(
	displayname:String,
	istimed:bool,
	time = 0 
):
	effectname = displayname
	timedeffect = istimed
	lifetime = time

func _ready():
	if timedeffect:
		lifetimer.wait_time = lifetime
		lifetimer.start()
		lifetimer.timeout.connect(effectend())
	
	if overtime["active"]:
		interval.wait_time = overtime["interval"]
		interval.start()
		interval.timeout.connect(intervalend())
func intervalend():
	effect_interval_timeout.emit()

func effectend():
	effect_end.emit()
