@tool
extends Resource
class_name Projectile

#region export properties
@export_group("meta")
@export var ProjectileName:String = "projectile"
@export var source:String ="God"

@export_group("projectile settings")
@export var mesh:Mesh
@export_range(0.1,100,0.1,"suffix:kg") var mass:float
# @export var mass:float = 0
@export var gravityScale:float=1.0
#endregion
@export_tool_button("generate") var testAction = test

func test():
	# var body = RigidBody3D.new()
	# body.mass = mass
	# body.gravity_scale = gravityScale
	
	# var collider = CollisionShape3D.new()
	# collider.shape = SphereShape3D
	# body.add_child(collider)

	# add_child(body)
	
	# var node = Node3D.new()
	
	# node.add_child(body)
	# body.owner = node
	# var scene = PackedScene.new()

	# var package = scene.pack(node)
	# if package == OK:
	# 	var error = ResourceSaver.save(scene,"res://components/preview/test.tscn")
	# 	if error != OK:
	# 		push_error("an error occured while saving this scene.")
	# 	else:
	# 		print("file saved in previews")

	# open scene after all this tuff
	var previewSene = PackedScene.new()

	#  generate parts of the scene 
	var body = generateProjectile()

	var packed = previewSene.pack(body)
	# test for errors
	if packed == OK:
		var error = ResourceSaver.save(previewSene,"res://components/preview/preview.tscn")
		if error != OK:
			push_error("an error occured while saving preview")
		else:
			print("preview generated")
	
	EditorInterface.open_scene_from_path("res://components/preview/preview.tscn")

func generateProjectile() -> RigidBody3D :
	# ):
	# rigidbody setup
	var body = RigidBody3D.new()
	body.mass = mass
	body.gravity_scale = gravityScale

	# collision setup 
	var collider = CollisionShape3D.new()
	collider.shape = SphereShape3D

	# shape setup 
	var shape = MeshInstance3D.new()
	shape.mesh = mesh

	body.add_child(collider)
	collider.owner = body

	body.add_child(shape)
	shape.owner = body

	return body
