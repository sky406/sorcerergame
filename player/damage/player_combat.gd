extends Node
class_name PlayerCombat
## Attach as a child Node under the PlayerController (the CharacterBody3D root
## of SCN_player_controller.tscn), as a sibling of the "CombatantStats" node.
##
## Requires DamageSystem to be set up as an Autoload:
##   Project Settings > Autoload > Path: damage_system.gd, Name: DamageSystem
##
## Left click swings at anything currently standing inside the attack hitbox,
## and (if weapon_point_path is set) plays a simple swing animation on your
## sword's pivot node - e.g. "../claire_pawn/WeaponPoint".

@export var damage_components: Array[DamageComponent] = []
@export var attack_range: float = 2.0
@export var attack_radius: float = 1.5
@export var attack_cooldown: float = 0.6
@export var weapon_point_path: NodePath  # e.g. "../claire_pawn/WeaponPoint"

var _combatant_stats: CombatantStats
var _targets_in_range: Array = []
var _cooldown_left: float = 0.0
var _weapon_point: Node3D
var _swing_tween: Tween

func _ready() -> void:
	_combatant_stats = get_parent().get_node("CombatantStats")
	if weapon_point_path != NodePath(""):
		_weapon_point = get_node_or_null(weapon_point_path)

	var hitbox := Area3D.new()
	hitbox.name = "PlayerAttackHitbox"
	hitbox.collision_layer = 0
	var shape := CollisionShape3D.new()
	var sphere := SphereShape3D.new()
	sphere.radius = attack_radius
	shape.shape = sphere
	hitbox.add_child(shape)
	get_parent().call_deferred("add_child", hitbox)
	hitbox.position = Vector3(0, 1, -attack_range)
	hitbox.body_entered.connect(_on_body_entered)
	hitbox.body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	if _cooldown_left > 0.0:
		_cooldown_left -= delta

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_try_attack()

func _on_body_entered(body: Node) -> void:
	if body.has_method("get_combatant_stats") and not _targets_in_range.has(body):
		_targets_in_range.append(body)

func _on_body_exited(body: Node) -> void:
	_targets_in_range.erase(body)

func _try_attack() -> void:
	if _cooldown_left > 0.0 or _combatant_stats == null:
		return
	_cooldown_left = attack_cooldown
	_play_swing()
	for body in _targets_in_range.duplicate():
		if not is_instance_valid(body):
			continue
		var defender: CombatantStats = body.get_combatant_stats()
		if defender:
			DamageSystem.apply_hit(_combatant_stats, defender, damage_components)

func _play_swing() -> void:
	if _weapon_point == null:
		return
	if _swing_tween:
		_swing_tween.kill()
	var start_rot := _weapon_point.rotation_degrees
	_swing_tween = create_tween()
	_swing_tween.tween_property(_weapon_point, "rotation_degrees:x", start_rot.x - 70.0, attack_cooldown * 0.35)
	_swing_tween.tween_property(_weapon_point, "rotation_degrees:x", start_rot.x, attack_cooldown * 0.35)
