@tool
extends Node3D
@export var title:String
	#set(value):
		#label.text = value
@export var onCollide:Callable = testprint
@onready var label = $Label3D

signal playerColided()
#func _ready():
	#pass
	##label.text = title
#
## func _process(delta: float):
## 	if Engine.is_editor_hint():
## 		label.text = title

func _process(delta: float) -> void:
	label.text = title

func _on_area_3d_body_entered(body:Node3D):
	if Global.isPlayer(body):
		onCollide.call(body)

func testprint(body:Node3D):
	var detectionString = "%s has entered"
	var printedString = detectionString % body
	print(printedString)
