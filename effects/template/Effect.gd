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
# var effectOn=false
var effect:Array = []
signal effect_timeout(effectName)
signal effect_added
signal effect_removed
signal effect_interval_timeout
signal overtime_effect_timeout(effect:Array)



# func _init(
# 	displayname:String,
# 	istimed:bool=false,
# 	time = 0,
# 	canstack:bool=false,
# ):
# 	effectname = displayname
# 	timedeffect = istimed
# 	lifetime = time

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
	effect_timeout.emit()

func getEffects():
	return effect
