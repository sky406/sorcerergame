extends MeshInstance3D
@onready var effectarea = $CollisionShape3D
var effect = Effect.new("testeffect",false)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	print("entered")




func _on_area_3d_body_exited(body):
	print("exit")
	
func _effec_added():
	pass
