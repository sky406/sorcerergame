# LingeringEffect.gd
extends Resource

# Properties
@export var name: String = "" # e.g., "Burn", "Dazed"
@export var duration: float = 0.0 # Duration in seconds
@export var potency: float = 1.0 # How strong the effect is, may scale with attacker's stats

# Apply the effect to the target (e.g., reduce stats or add status)
func apply_effect(target):
	# This is a placeholder - implement specific effects based on the type of effect
	if name == "Burn":
		target.health -= potency
	elif name == "Dazed":
		target.speed *= 0.5 # Example: reduce target speed

# Update the effect over time, reducing duration and adjusting potency if needed
func update(delta: float) -> bool:
	duration -= delta
	return duration <= 0 # Return true if the effect should end

# Remove the effect when it ends, restoring any modified stats
func remove_effect(target):
	if name == "Dazed":
		target.speed /= 0.5 # Reset speed if "Dazed"
