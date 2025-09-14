extends Node
class_name Effect
@onready var lifetimer = $lifetimer
@onready var interval = $intervaltimer
@export var effect:effectDat

signal effect_timeout(effect)
signal effect_added(effect)
signal effect_removed(effect)
signal effect_interval_timeout(effect)
signal overtime_effect_timeout(effect)

# func get_EffectDetails():
func get_Effect():return effect
func _ready():
	if effect.isTimed:
		lifetimer.wait_time = effect.lifeTime
		lifetimer.start()
	if effect.overtime:
		interval.wait_time = effect.overtimeInterval
		interval.start()
		
		
func _intervalend():
	var overtimeNode = effect.overtimeEffect.instantiate()
	call_deferred("add_child",overtimeNode)
	

func effectend():
	effect_timeout.emit(effect)
	queue_free()

func getEffects():
	return effect

func _on_tree_exiting():
	effect_removed.emit(effect)
