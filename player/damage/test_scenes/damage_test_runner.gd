extends Node

@export var spell: Spell
@export var damage_system: DamageSystem
@export var attacker: CombatantStats
@export var defender: CombatantStats

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if spell == null or damage_system == null or attacker == null or defender == null:
			push_warning("Assign spell/damage_system/attacker/defender in Inspector.")
			return

		var total = damage_system.apply_hit(attacker, defender, spell.damage_components)
		print("Rolled total damage: ", total, " | defender hp: ", defender.health)
