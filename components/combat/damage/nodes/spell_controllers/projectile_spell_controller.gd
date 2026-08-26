""""
SpellController 
-> finds targets 
-> calls DamageSystem.apply_hit(caster, target, spell.damage_components)
"""
extends Node
class_name ProjectileSpellController

@export var damage_system: DamageSystem
@export var spell: Spell
@export var caster_stats_path: NodePath
@export var speed: float = 20.0

var caster_stats: Attributes

func _ready():
	caster_stats = get_node(caster_stats_path) as Attributes

func on_hit(target_node: Node) -> void:
	if spell == null or damage_system == null or caster_stats == null:
		return

	# Expect target has Attributes child or component
	var target_stats := target_node.get_node_or_null("Attributes") as Attributes
	if target_stats == null:
		# optionally search deeper or via groups
		return

	damage_system.apply_hit(caster_stats, target_stats, spell.damage_components)

	# destroy projectile
	queue_free()
