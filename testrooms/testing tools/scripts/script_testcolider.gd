# @tool
extends Node3D
@export var title:String
@export var onCollide:Callable = testprint
@onready var label = $Label3D

func _ready():
	label.text = title

# func _process(delta: float):
# 	if Engine.is_editor_hint():
# 		label.text = title


func _on_area_3d_body_entered(body:Node3D):
	if Global.isPlayer(body):
		onCollide.call(body)

func testprint(body:Node3D):
	var detectionString = "%s has entered"
	var printedString = detectionString % body
	print(printedString)
