extends Control


@onready var attacker_stats: Attributes = $AttackerAttributes
@onready var defender_stats: Attributes = $DefenderAttributes

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

# Initializes the damage test UI, connects signals/buttons, and resets the combatants.
func _ready() -> void:
	_set_default_values()

	apply_hit_button.pressed.connect(_on_apply_hit_pressed)
	apply_three_hits_button.pressed.connect(_on_apply_three_hits_pressed)
	reset_button.pressed.connect(_on_reset_pressed)

	defender_stats.damage_taken.connect(_on_defender_damaged)
	defender_stats.effect_applied.connect(_on_effect_applied)
	defender_stats.died.connect(_on_defender_died)

	_reset_combatants()
	
	
func _on_defender_died() -> void:
	_append_history(
		"\n" + "Defender died."
	)

# Sets the default values and limits for all damage test inputs and buttons.
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

# Resets the attacker and defender stats, clears combat state, and resets the output display.
func _reset_combatants() -> void:
	_initialize_attacker_attributes()
	_initialize_defender_attributes()

	var defender_hp := defender_stats.getHP()

	if defender_hp != null:
		defender_hp.setMaxValue(
			float(health_input.value)
		)

		defender_hp.fullHeal()

	defender_stats.recentDamageHits.clear()

	history_output.clear()

	_update_result("Damage Result")

func _initialize_attacker_attributes() -> void:
	var attribs: Dictionary[String, Attribute] = {
		"strength": Attribute.new(
			float(attack_input.value)
		),
		"dexterity": Attribute.new(10),
		"constitution": Attribute.new(10),
		"inteligence": Attribute.new(10),
		"wisdom": Attribute.new(10),
		"charisma": Attribute.new(10),
		"level": Attribute.new(
			1,
			false,
			20,
			true
		)
	}

	attacker_stats._setAttributes(attribs)


func _initialize_defender_attributes() -> void:
	var attribs: Dictionary[String, Attribute] = {
		"strength": Attribute.new(10),
		"dexterity": Attribute.new(10),
		"constitution": Attribute.new(10),
		"inteligence": Attribute.new(10),
		"wisdom": Attribute.new(10),
		"charisma": Attribute.new(10),
		"level": Attribute.new(
			1,
			false,
			20,
			true
		)
	}

	defender_stats._setAttributes(attribs)

# Updates the attacker and defender combat stats using the current UI input values.
func _configure_combatants() -> void:
	# Update the attacker Strength score from the UI.
	if attacker_stats.attributes.has("strength"):
		attacker_stats.attributes["strength"].value = (
			float(attack_input.value)
		)

	var damage_type := _get_damage_type()

	var hp := defender_stats.getHP()

	if hp == null:
		return

	hp.resistances.clear()
	hp.vulnerabilities.clear()
	hp.immune.clear()

	var resistance_decimal := (
		float(resistance_input.value)
		/ 100.0
	)

	if resistance_decimal > 0.0:
		hp.resistances[damage_type] = (
			resistance_decimal
		)

	if vulnerable_check.button_pressed:
		# 1.0 = 100% extra damage = x2.
		hp.vulnerabilities[damage_type] = 1.0

	if immune_check.button_pressed:
		hp.immune.append(damage_type)
		
# Creates a DamageComponent from the current dice, damage type, bonuses, and lingering effect inputs.
func _create_damage_component() -> DamageComponent:
	var die := Die.new()

	die.numdice = int(
		dice_count_input.value
	)

	die.dietype = int(
		dice_sides_input.value
	)

	var damage_type := DamageType.new()

	damage_type.type = _get_damage_type()

	damage_type.display_name = (
		DamageTypes.types.keys()[
			damage_type.type
		].capitalize()
	)

	damage_type.die = die

	var lingering_name := (
		lingering_input.text
		.strip_edges()
		.to_lower()
	)

	if not lingering_name.is_empty():
		var effect := _create_test_lingering_effect(
			lingering_name
		)

		damage_type.possible_lingering.append(
			effect
		)

	var component := DamageComponent.new()

	component.damage_type = damage_type

	component.flat_bonus = int(
		flat_bonus_input.value
	)

	component.effect_bonus = int(
		effect_bonus_input.value
	)

	# For this tester, attacks scale with Strength.
	component.scaling_attribute = "strength"

	# Keep this false initially so you can isolate
	# attribute scaling from proficiency.
	component.add_proficiency = false

	return component
	
func _create_test_lingering_effect(
	effect_name: String
) -> Effect:
	var effect := Effect.new()

	effect.effectName = effect_name

	# Effect must target a valid Attribute because
	# Attributes.applyEffect() routes it there.
	effect.targetAttribute = "hp"

	effect.stackable = false

	# For now this test effect only proves that lingering
	# application works. Overtime behaviour can be tested
	# separately once Pass 10 is complete.
	effect.ammount = 0.0

	return effect
	
# Gets and normalizes the entered damage type, defaulting to "untyped" when empty.
func _get_damage_type() -> DamageTypes.types:
	var value := (
		damage_type_input.text
		.strip_edges()
		.to_lower()
	)

	match value:
		"bludgeouning", "bludgeoning":
			return DamageTypes.types.bludgeouning

		"slashing":
			return DamageTypes.types.slashing

		"piercing":
			return DamageTypes.types.piercing

		"fire":
			return DamageTypes.types.fire

		"cold":
			return DamageTypes.types.cold

		"lightning":
			return DamageTypes.types.lightning

		"aether":
			return DamageTypes.types.aether

		"blight", "void":
			return DamageTypes.types.blight

		_:
			# Temporary safe fallback for tester.
			return DamageTypes.types.slashing
			
# Configures the combatants, creates the test damage component, and applies one hit through the DamageSystem.
func _apply_test_hit() -> Dictionary:
	_configure_combatants()

	var component := _create_damage_component()
	var components: Array[DamageComponent] = [component]

	return DamageSystem.apply_hit_detailed(
		attacker_stats,
		defender_stats,
		components
	)

# Applies one test hit when the Apply One Hit button is pressed and displays its report.
func _on_apply_hit_pressed() -> void:
	var report := _apply_test_hit()
	_display_attack_report(report)

# Formats and displays the detailed results of a single attack.
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
			"Scaling Attribute: %s"
				% str(
					component_report[
						"scaling_attribute"
					]
				).capitalize()
		)

		output_lines.append(
			"Scaling Bonus: %s"
				% _format_signed_number(
					int(
						component_report[
							"scaling_bonus"
						]
					)
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
						"lingering_effect_name"
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

# Converts an array of dice roll values into a readable string.
func _format_rolls(rolls: Array) -> String:
	if rolls.is_empty():
		return "[]"

	var values: Array[String] = []

	for roll_value in rolls:
		values.append(str(roll_value))

	return "[" + ", ".join(values) + "]"

# Formats an integer with an explicit plus sign when the value is positive or zero.
func _format_signed_number(value: int) -> String:
	if value >= 0:
		return "+%d" % value

	return str(value)

# Converts a boolean value into a readable "Yes" or "No" string.
func _yes_or_no(value: bool) -> String:
	if value:
		return "Yes"

	return "No"

# Applies three consecutive test hits and displays their combined results.
func _on_apply_three_hits_pressed() -> void:
	var reports: Array[Dictionary] = []
	var sequence_health_before := int(
		defender_stats.getCurrentHP()
	)

	for _hit_number in range(3):
		var report := _apply_test_hit()
		reports.append(report)

	_display_multi_hit_report(
		reports,
		sequence_health_before,
		int(defender_stats.getCurrentHP())
	)

# Formats and displays the individual and combined results of a multi-hit sequence.
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

				var effect_name := str(
					component_report[
						"lingering_effect_name"
					]
				)

				if (
					not effect_name.is_empty()
					and effect_name not in triggered_effects
				):
					triggered_effects.append(
						effect_name
					)

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

# Resets the combatants and damage test state when the Reset button is pressed.
func _on_reset_pressed() -> void:
	_reset_combatants()

# Receives the defender's damaged signal for handling damage-related UI or test behavior.
func _on_defender_damaged(
	_amount: float,
	_damage_type: DamageTypes.types
) -> void:
	pass

# Receives the lingering effect signal for handling newly applied lingering effects.
func _on_effect_applied(
	_effect: Effect
) -> void:
	pass

# Updates the result label with the latest message, defender health, and active effects.
func _update_result(message: String) -> void:
	result_label.text = (
		"Damage Result\n"
		+"%s\n"
		+ "Defender HP: %d / %d\n"
		+ "Active effects: %s"
	) % [
		message,
		int(defender_stats.getCurrentHP()),
		int(defender_stats.getMaxHP()),
		_get_active_effect_names()
	]

# Returns a readable list of the defender's active lingering effects, or "None" if there are none.
func _get_active_effect_names() -> String:
	var hp := defender_stats.getHP()

	if hp == null:
		return "None"

	if hp.effects_applied.is_empty():
		return "None"

	var names: Array[String] = []

	for effect in hp.effects_applied:
		if (
			effect.effectName
			not in names
		):
			names.append(
				effect.effectName
			)

	return ", ".join(names)
	
# Adds a new message to the damage history output.
func _append_history(message: String) -> void:
	history_output.append_text("\n" + message + "\n")
