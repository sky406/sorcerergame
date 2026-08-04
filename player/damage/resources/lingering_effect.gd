extends Resource
class_name LingeringEffect

@export var id: String = ""         # "burn", "bleeding"
@export var duration: float = 5.0
@export var potency: float = 1.0

func apply_tick(target_stats: CombatantStats, delta: float) -> void:
	match id:
		"burn":
			# damage per second
			var dmg := int(round(potency * delta))
			target_stats.health = max(target_stats.health - dmg, 0)
		"bleeding":
			var dmg := int(round((potency * 0.5) * delta))
			target_stats.health = max(target_stats.health - dmg, 0)
		_:
			pass

func update(delta: float) -> bool:
	duration -= delta
	return duration <= 0.0

func remove(target_stats: CombatantStats) -> void:
	# later: undo speed debuffs etc
	pass
