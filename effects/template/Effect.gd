extends Node
@export var icon:Image = null
@export var effectname = "template"
@onready var lifetimer = $lifetimer
@onready var interval = $intervaltimer
@export var targetAttribute:Node = null
var displayeffect:bool = false
var timedeffect:bool = false
var isstackbale:bool = false
var lifetime:float = 0
var affectedattributes ={}
var overtime:Dictionary = {"active":false,"interval":0,"affectedattributes":[]} 
# the affected attributes tag is supposed to be an array of disctionaries in this format in this format {str:-1,limit:20,}
var damagebonus:Dictionary = {} # this should only be dice or numbers

signal effect_end
signal effect_added
signal effect_removed
signal effect_overtime_timeout

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
		# lifetimer.start()
	
	if overtime["active"]:
		interval.wait_time = overtime["interval"]
		# interval.start()

