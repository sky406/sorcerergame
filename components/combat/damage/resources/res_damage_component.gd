"""
Data only.
Describes one component of damage and the bonuses/scaling used to calculate it.
"""
class_name DamageComponent
extends Resource

# Stores the DamageType that determines this component's type, damage dice, and possible lingering effects.
@export var damage_type: DamageType

# Stores a permanent flat damage bonus built into the weapon, spell, or other damage source.
@export var flat_bonus: int = 0

# Stores a temporary damage bonus supplied at runtime by active effects.
var effect_bonus: int = 0

# Determines which character attribute, if any, is used to scale this component's damage
@export_enum(
	"none",
	"strength",
	"dexterity",
	"constitution",
	"inteligence",
	"wisdom",
	"charisma"
)
var scaling_attribute: String = "none"

# Determines whether the attacker's proficiency bonus is added to this damage component.
@export var add_proficiency: bool = false
