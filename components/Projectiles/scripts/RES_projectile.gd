@tool
extends Resource
class_name Projectile

#region export properties
@export_group("meta")
@export var ProjectileName:String = "projectile"
@export var source:String ="God"

@export_group("projectile settings")
@export var mesh:Mesh
@export var collisionMesh:Shape3D
@export var physicsMaterialOverride:PhysicsMaterial
@export_range(0.1,100,0.1,"suffix:kg") var mass:float
# @export var mass:float = 0
@export var gravityScale:float=1.0
#endregion
@export_tool_button("generate") var testAction = test



func test():

	# var previewSene = PackedScene.new()

	# #  generate parts of the scene 
	# var body = generateProjectile()

	# var packed = previewSene.pack(body)
	# # test for errors
	# # undo_redo.create_action("create preview scene")
	# if packed == OK:
	# 	var error = ResourceSaver.save(previewSene,"res://components/preview/preview.tscn")
	# 	if error != OK:
	# 		push_error("an error occured while saving preview")
	# 	else:
	# 		print("preview generated")
	
	var undo_redo= EditorInterface.get_editor_undo_redo()
	# EditorInterface.open_scene_from_path("res://components/preview/preview.tscn")
	undo_redo.create_action("create preview")
	undo_redo.add_do_method(self,"createPreview")
	undo_redo.add_undo_method(self,"deletePreview")
	undo_redo.add_do_reference(self)
	undo_redo.commit_action()
	# ngl this doesn't even work lmao

func createPreview():
	var previewSene = PackedScene.new()

	#  generate parts of the scene 
	var body = generateProjectile()

	var packed = previewSene.pack(body)
	# test for errors
	if packed == OK:
		var error = ResourceSaver.save(previewSene,"res://components/preview/%spreview.tscn"%[ProjectileName])
		if error != OK:
			push_error("an error occured while saving preview")
		else:
			print("preview generated")
	
	EditorInterface.open_scene_from_path("res://components/preview/%spreview.tscn"%[ProjectileName])

func deletePreview():
	var dir = DirAccess.open("res://components/preview/")
	if dir.dir_exists("%spreview.tscn"%[ProjectileName]):
		var error = dir.remove("%spreview.tscn"%[ProjectileName])
		if error != OK:
			push_error("failed to delete preview")



func generateProjectile() -> RigidBody3D :
	# ):
	# rigidbody setup
	var body = RigidBody3D.new()
	body.mass = mass
	body.gravity_scale = gravityScale
	body.physics_material_override = physicsMaterialOverride
	body.name = ProjectileName

	# collision setup 
	var collider = CollisionShape3D.new()
	collider.shape = collisionMesh
	collider.name = "%scollider"%[ProjectileName]
	# shape setup 
	var shape = MeshInstance3D.new()
	shape.mesh = mesh
	shape.name = "%shape"%[ProjectileName]

	body.add_child(collider)
	collider.owner = body

	body.add_child(shape)
	shape.owner = body

	return body
