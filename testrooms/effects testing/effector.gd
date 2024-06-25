extends MeshInstance3D
@onready var effectarea = $CollisionShape3D
#var effect = Effect.new("testeffect",false)
# Called when the node enters the scene tree for the first time.
var effectname= 1
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	print("entered")
	#print (body.get_property_list())
	print(body.name)
	var list = body.get_property_list()
	for i in list:
		if i["name"] == "attributes":
			body.attributes.addEffect(
				{"name":effectname,
				"effects": [],
			"icon":null,
			"properties":{
				"displayeffect":false,
				"timedeffect": false,
				"canstack":true,
				"lifetime":0
			},
			"overtime":{"active":true,"interval":effectname}}
			)
	effectname+=1



func _on_area_3d_body_exited(body):
	print("exit")
	
func _effec_added():
	pass
