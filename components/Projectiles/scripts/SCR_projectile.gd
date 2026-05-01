extends Node
class_name Projectile

#region export properties
@export_group("meta")
@export var ProjectileName:String = "projectile"
@export var source:String ="God"

@export_group("projectile settings")
@export var mesh:Mesh
@export var mass:float = 0
@export var gravityScale:float=1.0
#endregion
