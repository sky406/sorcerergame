extends Node

var inputDir:Vector2 = Vector2.ZERO
var mouseDelta:Vector2 = Vector2.ZERO # process the camera inputs in the player controller node
var jump:bool = false
var inputEnabled = true
# var direction:Vector3
signal jumpPressed()#):
signal mouseMovement(mouseDelta:Vector2)#):
# signal inputHeld(input)


# ):
func _physics_process(delta: float):
	if Input.is_action_just_pressed("jump"):
		jumpPressed.emit()
	processInputs()

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
		mouseMovement.emit(mouseDelta)

func _process(delta: float):
	mouseDelta = Vector2.ZERO



func processInputs():
	if inputEnabled:

		inputDir = Input.get_vector("strafeLeft","strafeRight","moveForward","moveBackward")
		
		jump =  Input.is_action_just_pressed("jump")


#TODO combien the inputs with the player
