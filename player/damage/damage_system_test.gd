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
@onready var history_output: RichTextLabel = %ResultOutput


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
	_update_result("Damage Result")


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


func _apply_test_hit() -> Dictionary:
	_configure_combatants()

	var component := _create_damage_component()
	var components: Array[DamageComponent] = [component]

	return DamageSystem.apply_hit_detailed(
		attacker_stats,
		defender_stats,
		components
	)

func _on_apply_hit_pressed() -> void:
	var report := _apply_test_hit()
	_display_attack_report(report)

func _display_attack_report(report: Dictionary) -> void:
	var output_lines: Array[String] = []

	output_lines.append("")

	var components: Array = report["components"]

	for index in range(components.size()):
		var component_report: Dictionary = components[index]

		if components.size() > 1:
			output_lines.append(
				"COMPONENT %d"
				% [index + 1]
			)
			output_lines.append("")

		output_lines.append(
			"Damage Type: %s"
				% component_report["damage_type_name"]
		)

		output_lines.append(
			"Dice: %s"
				% _format_rolls(
					component_report["dice_rolls"]
				)
		)

		output_lines.append(
			"Dice Total: %d"
				% int(component_report["dice_total"])
		)

		output_lines.append(
			"Attack Bonus: %s"
				% _format_signed_number(
					int(component_report["attack_bonus"])
				)
		)

		output_lines.append(
			"Flat Bonus: %s"
				% _format_signed_number(
					int(component_report["flat_bonus"])
				)
		)

		output_lines.append(
			"Effect Bonus: %s"
				% _format_signed_number(
					int(component_report["effect_bonus"])
				)
		)

		output_lines.append(
			"Raw Damage: %d"
				% int(component_report["raw_damage"])
		)

		output_lines.append(
			"Resistance: %.0f%%"
				% (
					float(component_report["resistance"])
					* 100.0
				)
		)

		output_lines.append(
			"After Resistance: %d"
				% int(
					component_report[
						"damage_after_resistance"
					]
				)
		)

		output_lines.append(
			"Vulnerable: %s"
				% _yes_or_no(
					bool(
						component_report[
							"is_vulnerable"
						]
					)
				)
		)

		output_lines.append(
			"Immune: %s"
				% _yes_or_no(
					bool(
						component_report[
							"is_immune"
						]
					)
				)
		)

		output_lines.append(
			"Final Damage: %d"
				% int(component_report["final_damage"])
		)

		output_lines.append(
			"Enemy HP: %d → %d"
				% [
					int(component_report["health_before"]),
					int(component_report["health_after"])
				]
		)

		output_lines.append(
			"Lingering Counter: %d / %d"
				% [
					int(
						component_report[
							"lingering_count_after"
						]
					),
					int(
						component_report[
							"lingering_hits_required"
						]
					)
				]
		)

		var lingering_applied := bool(
			component_report["lingering_applied"]
		)

		output_lines.append(
			"Lingering Applied: %s"
				% _yes_or_no(lingering_applied)
		)

		if lingering_applied:
			output_lines.append(
				"Lingering Effect: %s"
					% component_report[
						"lingering_effect_id"
					]
			)

		output_lines.append("")

	output_lines.append(
		"TOTAL DAMAGE: %d"
			% int(report["total_damage"])
	)

	output_lines.append(
		"TOTAL HP CHANGE: %d → %d"
			% [
				int(report["health_before"]),
				int(report["health_after"])
			]
	)

	history_output.text = "\n".join(output_lines)

	_update_result(
		"Last hit: %d damage"
			% int(report["total_damage"])
	)

func _format_rolls(rolls: Array) -> String:
	if rolls.is_empty():
		return "[]"

	var values: Array[String] = []

	for roll_value in rolls:
		values.append(str(roll_value))

	return "[" + ", ".join(values) + "]"

func _format_signed_number(value: int) -> String:
	if value >= 0:
		return "+%d" % value

	return str(value)

func _yes_or_no(value: bool) -> String:
	if value:
		return "Yes"

	return "No"

func _on_apply_three_hits_pressed() -> void:
	var reports: Array[Dictionary] = []
	var sequence_health_before := defender_stats.health

	for _hit_number in range(3):
		var report := _apply_test_hit()
		reports.append(report)

	_display_multi_hit_report(
		reports,
		sequence_health_before,
		defender_stats.health
	)

func _display_multi_hit_report(
	reports: Array[Dictionary],
	sequence_health_before: int,
	sequence_health_after: int
) -> void:
	var output_lines: Array[String] = []

	output_lines.append("")
	output_lines.append("MULTI-HIT SUMMARY")
	output_lines.append("")

	var sequence_total_damage := 0
	var lingering_triggered := false
	var triggered_effects: Array[String] = []

	for hit_index in range(reports.size()):
		var report: Dictionary = reports[hit_index]
		var hit_damage := int(report["total_damage"])

		sequence_total_damage += hit_damage

		output_lines.append(
			"HIT %d"
			% [hit_index + 1]
		)

		var components: Array = report["components"]

		for component_value in components:
			var component_report: Dictionary = component_value

			output_lines.append(
				"Damage Type: %s"
				% component_report["damage_type_name"]
			)

			output_lines.append(
				"Dice: %s"
				% _format_rolls(
					component_report["dice_rolls"]
				)
			)

			output_lines.append(
				"Dice Total: %d"
				% int(component_report["dice_total"])
			)

			output_lines.append(
				"Raw Damage: %d"
				% int(component_report["raw_damage"])
			)

			output_lines.append(
				"Resistance: %.0f%%"
				% (
					float(component_report["resistance"])
					* 100.0
				)
			)

			output_lines.append(
				"Final Damage: %d"
				% int(component_report["final_damage"])
			)

			output_lines.append(
				"Enemy HP: %d → %d"
				% [
					int(component_report["health_before"]),
					int(component_report["health_after"])
				]
			)

			var effect_applied := bool(
				component_report["lingering_applied"]
			)

			if effect_applied:
				lingering_triggered = true

				var effect_id := str(
					component_report["lingering_effect_id"]
				)

				if (
					not effect_id.is_empty()
					and effect_id not in triggered_effects
				):
					triggered_effects.append(effect_id)

				output_lines.append(
					"Lingering Counter: Triggered at %d / %d; reset to 0"
						% [
							int(
								component_report[
									"lingering_hits_required"
								]
							),
							int(
								component_report[
									"lingering_hits_required"
								]
							)
						]
				)
			else:
				output_lines.append(
					"Lingering Counter: %d / %d"
						% [
							int(
								component_report[
									"lingering_count_after"
								]
							),
							int(
								component_report[
									"lingering_hits_required"
								]
							)
						]
				)

		output_lines.append(
			"Hit %d Total: %d"
				% [hit_index + 1, hit_damage]
		)

		output_lines.append("")

	output_lines.append("--------------------")

	output_lines.append(
		"SEQUENCE TOTAL DAMAGE: %d"
			% sequence_total_damage
	)

	output_lines.append(
		"SEQUENCE HP CHANGE: %d → %d"
			% [
				sequence_health_before,
				sequence_health_after
			]
	)

	output_lines.append(
		"Lingering Triggered: %s"
			% _yes_or_no(lingering_triggered)
	)

	if not triggered_effects.is_empty():
		output_lines.append(
			"Lingering Effects Applied: %s"
				% ", ".join(triggered_effects)
		)

	history_output.text = "\n".join(output_lines)

	_update_result(
		"Three hits dealt %d total damage"
			% sequence_total_damage
	)

func _on_reset_pressed() -> void:
	_reset_combatants()


func _on_defender_damaged(
	_amount: int,
	_damage_type_id: String
) -> void:
	pass


func _on_lingering_applied(
	_effect_id: String
) -> void:
	pass


func _update_result(message: String) -> void:
	result_label.text = (
		"Damage Result\n"
		+"%s\n"
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
	history_output.append_text("\n" + message + "\n")
