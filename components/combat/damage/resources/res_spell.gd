extends Resource
class_name Spell

@export var name: String = "Spell"
@export var energy_cost: int = 10
@export var category: String = "projectile" # projectile/area/blast/summon

@export var damage_components: Array[DamageComponent] = []
