"""
CombatantStats 
-> stores HP/resists/statuses 
    + ticks lingering over time
"""

extends Node
class_name CombatantStats

@export var max_health: int = 100
@export var health: int = 100
@export var attack: int = 10

# Key these by damage_type.id (NOT display strings)
@export var resistances: Dictionary = {}       # {"fire": 0.2}
@export var vulnerabilities: Array[String] = [] # ["cold"]
@export var immunities: Array[String] = []      # ["blight"]

var lingering_effects: Array[LingeringEffect] = []

# For lingering buildup: {"fire": [t1,t2,t3], ...}
var recent_hits: Dictionary = {}

signal damaged(amount: int, damage_type_id: String)
signal lingering_applied(effect_id: String)

func apply_lingering(effect: LingeringEffect) -> void:
	lingering_effects.append(effect)
	emit_signal("lingering_applied", effect.id)

func _process(delta: float) -> void:
	_update_lingering(delta)

func _update_lingering(delta: float) -> void:
	for e in lingering_effects.duplicate():
		e.apply_tick(self, delta)
		if e.update(delta):
			e.remove(self)
			lingering_effects.erase(e)
