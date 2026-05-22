extends Node3D

@onready var area = $Area3D
@export var fire_type: DamageType
var damage_system: DamageSystem

func _ready():
	damage_system = DamageSystem.new()
	add_child(damage_system)
	area.body_entered.connect(_on_body_entered)
	print("DamageTrigger ready! Watching for bodies...")

func _on_body_entered(body: Node3D):
	print("Something entered! Body: ", body.name)  # add this as first line
	if not Global.isPlayer(body):
		return
	
	var stats = body.get_node_or_null("CombatantStats")
	if stats == null:
		print("ERROR: Player has no CombatantStats node!")
		return
	
	# build the hit
	var comp = DamageComponent.new()
	comp.damage_type = fire_type
	comp.flat_bonus = 5
	
	var attacker = CombatantStats.new()
	attacker.attack = 10
	
	var total = damage_system.apply_hit(attacker, stats, [comp])
	
	# show floating damage number using Global
	Global.displayDamage(
		str(total),           # the number to show
		body.global_position + Vector3(0, 2, 0),  # above the player's head
		2.0,                  # launch power
		Global.rgbTocol(255, 100, 0)  # orange for fire
	)
	
	print("Fire hit! Dealt: ", total, " | Player HP: ", stats.health)
