extends MeshInstance3D
@onready var effectarea = $CollisionShape3D
@export var effect:effectDat
#var effect = Effect.new("testeffect",false)
# Called when the node enters the scene tree for the first time.
var effectname= 1
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body.has_node("attributes"):
		body.attributes._add_effect(effect)
	#print("entered")
	##print (body.get_property_list())
	#print(body.get("attributes").strength)
	#print(body.has_node("attributes"))
	#print(body.name)
	#var list = body.get_property_list()
	#for i in list:
		#if i["name"] == "attributes":
			#body.attributes.addEffect([
				#{"properties":
					#[
						#{"name":effectname},
						#{"display":true},
						#{"istimed":false},
						#{"icon":Image.load_from_file("res://assets/placeholder sprites/efecticon.png")}
					#]
					#},
				#{"effects":[
					#{"attribute":"constitution","value":-1,"limit":1}
				#]}]
			#)
	#effectname+=1



func _on_area_3d_body_exited(body):
	print("exit")
	
func _effec_added():
	pass
