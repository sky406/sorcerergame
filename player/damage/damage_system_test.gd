extends Control


@onready var attacker_stats: CombatantStats = $AttackerStats
@onready var defender_stats: CombatantStats = $DefenderStats

@onready var attack_input: SpinBox = %AttackInput

@onready var dice_count_input: SpinBox = %DiceCountInput
@onready var dice_sides_input: SpinBox = %DiceSidesInput
@onready var damage_type_input: LineEdit = %DamageTypeInput
@onready var flat_bonus_input: SpinBox = %FlatBonusInput
@onready var effect_bonus_input: SpinBox = %EffectBonusInput
@onready var lingering_input: LineEdit = %LingeringInput

@onready var health_input: SpinBox = %HealthInput
@onready var resistance_input: SpinBox = %ResistanceInput
@onready var immune_check: CheckBox = %ImmuneCheck
@onready var vulnerable_check: CheckBox = %VulnerableCheck

@onready var apply_hit_button: Button = %ApplyHitButton
@onready var apply_three_hits_button: Button = %ApplyMultipleHitsButton
@onready var reset_button: Button = %ResetButton

@onready var result_label: Label = %ResultLabel
@onready var history_output: RichTextLabel = %HistoryOutput


func _ready() -> void:
	_set_default_values()

	apply_hit_button.pressed.connect(_on_apply_hit_pressed)
	apply_three_hits_button.pressed.connect(_on_apply_three_hits_pressed)
	reset_button.pressed.connect(_on_reset_pressed)

	defender_stats.damaged.connect(_on_defender_damaged)
	defender_stats.lingering_applied.connect(_on_lingering_applied)

	_reset_combatants()


func _set_default_values() -> void:
	attack_input.min_value = 0
	attack_input.max_value = 100
	attack_input.value = 10

	dice_count_input.min_value = 1
	dice_count_input.max_value = 20
	dice_count_input.value = 1

	dice_sides_input.min_value = 2
	dice_sides_input.max_value = 100
	dice_sides_input.value = 6

	damage_type_input.text = "slashing"

	flat_bonus_input.min_value = -100
	flat_bonus_input.max_value = 100
	flat_bonus_input.value = 2

	effect_bonus_input.min_value = -100
	effect_bonus_input.max_value = 100
	effect_bonus_input.value = 0

	lingering_input.text = "bleeding"

	health_input.min_value = 1
	health_input.max_value = 10000
	health_input.value = 100

	resistance_input.min_value = 0
	resistance_input.max_value = 99
	resistance_input.suffix = "%"
	resistance_input.value = 0

	apply_hit_button.text = "Apply One Hit"
	apply_three_hits_button.text = "Apply Multiple Hits"
	reset_button.text = "Reset"


func _reset_combatants() -> void:
	attacker_stats.attack = int(attack_input.value)

	defender_stats.max_health = int(health_input.value)
	defender_stats.health = defender_stats.max_health

	defender_stats.resistances.clear()
	defender_stats.vulnerabilities.clear()
	defender_stats.immunities.clear()
	defender_stats.recent_hits.clear()
	defender_stats.lingering_effects.clear()

	history_output.clear()
	_update_result("Ready")


func _configure_combatants() -> void:
	var damage_type_id := _get_damage_type_id()

	attacker_stats.attack = int(attack_input.value)

	var resistance_decimal := float(resistance_input.value) / 100.0

	defender_stats.resistances.clear()
	if resistance_decimal > 0.0:
		defender_stats.resistances[damage_type_id] = resistance_decimal

	defender_stats.immunities.clear()
	if immune_check.button_pressed:
		defender_stats.immunities.append(damage_type_id)

	defender_stats.vulnerabilities.clear()
	if vulnerable_check.button_pressed:
		defender_stats.vulnerabilities.append(damage_type_id)


func _create_damage_component() -> DamageComponent:
	var die := Die.new()
	die.numdice = int(dice_count_input.value)
	die.dietype = int(dice_sides_input.value)

	var damage_type := DamageType.new()
	damage_type.id = _get_damage_type_id()
	damage_type.display_name = damage_type.id.capitalize()
	damage_type.die = die

	var lingering_id := lingering_input.text.strip_edges().to_lower()
	if not lingering_id.is_empty():
		damage_type.possible_lingering.append(lingering_id)

	var component := DamageComponent.new()
	component.damage_type = damage_type
	component.flat_bonus = int(flat_bonus_input.value)
	component.effect_bonus = int(effect_bonus_input.value)

	return component


func _get_damage_type_id() -> String:
	var value := damage_type_input.text.strip_edges().to_lower()

	if value.is_empty():
		return "untyped"

	return value


func _apply_test_hit() -> int:
	_configure_combatants()

	var component := _create_damage_component()
	var components: Array[DamageComponent] = [component]

	var health_before := defender_stats.health

	var total_damage := DamageSystem.apply_hit(
		attacker_stats,
		defender_stats,
		components
	)

	var health_after := defender_stats.health

	_append_history(
		"Hit completed | total=%d | health: %d → %d"
		% [total_damage, health_before, health_after]
	)

	_update_result("Last hit: %d damage" % total_damage)

	return total_damage


func _on_apply_hit_pressed() -> void:
	_apply_test_hit()


func _on_apply_three_hits_pressed() -> void:
	for hit_number in range(3):
		var damage := _apply_test_hit()

		_append_history(
			"Rapid hit %d dealt %d"
			% [hit_number + 1, damage]
		)


func _on_reset_pressed() -> void:
	_reset_combatants()


func _on_defender_damaged(
	amount: int,
	damage_type_id: String
) -> void:
	_append_history(
		"Signal: damaged(%d, \"%s\")"
		% [amount, damage_type_id]
	)


func _on_lingering_applied(effect_id: String) -> void:
	_append_history(
		"Signal: lingering_applied(\"%s\")"
		% effect_id
	)


func _update_result(message: String) -> void:
	result_label.text = (
		"%s\n"
		+ "Defender HP: %d / %d\n"
		+ "Active effects: %s"
	) % [
		message,
		defender_stats.health,
		defender_stats.max_health,
		_get_active_effect_names()
	]


func _get_active_effect_names() -> String:
	if defender_stats.lingering_effects.is_empty():
		return "None"

	var names: Array[String] = []

	for effect in defender_stats.lingering_effects:
		names.append(effect.id)

	return ", ".join(names)


func _append_history(message: String) -> void:
	history_output.append_text(message + "\n")
