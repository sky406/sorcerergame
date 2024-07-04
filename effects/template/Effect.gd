extends Node
@export var icon:Image = null
@export var effectname = "template"
@onready var lifetimer = $lifetimer
@onready var interval = $intervaltimer
@export var targetAttribute:Node = null
# main properties
var displayeffect:bool = false
var timedeffect:bool = false
var isstackable:bool = false
var lifetime:float = 0
var overtime:Dictionary = {"active":false,"interval":0,"damage":{},"effects":{}} 
# var effectOn=false
var effect:Array = []
signal effect_timeout(effectName)
signal effect_added(effectName)
signal effect_removed(effectName)
signal effect_interval_timeout(effectName)
signal overtime_effect_timeout(effectName)

func get_EffectDetails():
	return {
		"name":effectname,
		"effects": effect,
		"icon":icon,
		"properties":{
			"displayeffect":displayeffect,
			"timedeffect": timedeffect,
			"canstack":isstackable,
			"lifetime":lifetime
		},
		"overtime":overtime
	}

func get_Effect():return effect

func _ready():
	if timedeffect:
		lifetimer.wait_time = lifetime
		lifetimer.start()
		lifetimer.timeout.connect(effectend())
	
	if overtime["active"]:
		interval.wait_time = overtime["interval"]
		interval.timeout.connect(_intervalend)
		interval.start()
		
func _intervalend():
	effect_interval_timeout.emit(effectname)

func effectend():
	effect_timeout.emit()

func getEffects():
	return effect

func _on_tree_exiting():
	effect_removed.emit(effectname)
