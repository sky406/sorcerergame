# the interactable node is intended to be added to objects to make them "interactable"
extends Node3D
class_name Interactable
@export var collisionRadius = 2
@onready var collider = $InteractableRange/CollisionShape3D
@onready var collisionArea = $InteractableRange
@export var disabled:bool = false
@export var deleteOnUse:bool = false
@export var InteractMessage:String = "interact?"
@export var InteractAction:Callable 
@onready var player = Global.findPlayer()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collider.disabled = disabled
	var colliderShape:SphereShape3D = SphereShape3D.new()
	colliderShape.radius = collisionRadius
	collider.shape = colliderShape
	
func getLabel()->InteractLabel:
	var label = InteractLabel.new()
	label.InteractText = InteractMessage
	return label

func _on_interactable_range_body_entered(body: Node3D) -> void:
	# PS_InteractionManager.register_area(self)
	if body == player:
		player.interactionControl.registerArea(self)
	
func _on_interactable_range_body_exited(body: Node3D) -> void:
	if body == player:
		player.interactionControl.unregisterArea(self)
