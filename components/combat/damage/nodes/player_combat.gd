extends Node
class_name PlayerCombat

@export var damage_components: Array[DamageComponent] = []
@export var attack_range: float = 2.0
@export var attack_radius: float = 1.5
@export var attack_cooldown: float = 0.6
@export var weapon_point_path: NodePath  # e.g. "../claire_pawn/WeaponPoint"

var _attributes: Attributes
var _targets_in_range: Array = []
var _cooldown_left: float = 0.0
var _weapon_point: Node3D
var _swing_tween: Tween

func _ready() -> void:
	_attributes = get_parent().get_node_or_null(
		"attributes"
	)

	if _attributes == null:
		push_error(
			"PlayerCombat could not find the player's attributes node."
		)

	if weapon_point_path != NodePath(""):
		_weapon_point = get_node_or_null(
			weapon_point_path
		)

	var hitbox := Area3D.new()

	hitbox.name = "PlayerAttackHitbox"
	hitbox.collision_layer = 0

	var shape := CollisionShape3D.new()
	var sphere := SphereShape3D.new()

	sphere.radius = attack_radius
	shape.shape = sphere

	hitbox.add_child(shape)

	get_parent().call_deferred(
		"add_child",
		hitbox
	)

	hitbox.position = Vector3(
		0,
		1,
		-attack_range
	)

	hitbox.body_entered.connect(
		_on_body_entered
	)

	hitbox.body_exited.connect(
		_on_body_exited
	)
func _process(delta: float) -> void:
	if _cooldown_left > 0.0:
		_cooldown_left -= delta

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_try_attack()

func _on_body_entered(
	body: Node
) -> void:
	if (
		body.has_method("get_attributes")
		and not _targets_in_range.has(body)
	):
		_targets_in_range.append(body)

func _on_body_exited(body: Node) -> void:
	_targets_in_range.erase(body)

func _try_attack() -> void:
	if (
		_cooldown_left > 0.0
		or _attributes == null
	):
		return

	_cooldown_left = attack_cooldown

	_play_swing()

	for body in _targets_in_range.duplicate():
		if not is_instance_valid(body):
			continue

		var defender: Attributes = (
			body.get_attributes()
		)

		if defender == null:
			continue

		DamageSystem.apply_hit(
			_attributes,
			defender,
			damage_components
		)
		
func _play_swing() -> void:
	if _weapon_point == null:
		return
	if _swing_tween:
		_swing_tween.kill()
	var start_rot := _weapon_point.rotation_degrees
	_swing_tween = create_tween()
	_swing_tween.tween_property(_weapon_point, "rotation_degrees:x", start_rot.x - 70.0, attack_cooldown * 0.35)
	_swing_tween.tween_property(_weapon_point, "rotation_degrees:x", start_rot.x, attack_cooldown * 0.35)
