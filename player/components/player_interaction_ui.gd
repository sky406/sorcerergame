extends Control
var buttons:Array 
var selected:int = 0
@onready var buttonContainer = $"button container"
@export var showButtons:bool = true

# store the buttons for the near interactables
func _assignButtons(interactables:Array[Interactable]):
	var newButtons:Array = []
	for interact in interactables:
		newButtons.push_back(interact.getLabel())
	buttons = newButtons
	print(newButtons)
	if showButtons:
		_displayButtons()

#clear the old button array and add it to the UI
func _displayButtons():
	var children = buttonContainer.get_children()
	if children != []:
		for i in children:
			remove_child(i)
	for i in buttons:
		buttonContainer.add_child(i)

# TODO figure out why the ui won't display
