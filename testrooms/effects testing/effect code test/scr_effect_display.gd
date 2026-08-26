extends VBoxContainer
#@onready var player = Global.findPlayer()
var attribs:Dictionary
var attrLabels:Dictionary
const labelSettings = preload("res://testrooms/effects testing/effect code test/outlinedtextcos i'm lazy .tres")

func _ready() :
	var player:PlayerController = Global.findPlayer()
	attribs = player.attributes.attributes
	print(attribs)
	print(typeof(attribs.values()[0]))
	for attr in attribs.keys():
		var attribLabel:Label = Label.new()
		attribLabel.label_settings = labelSettings
		var attribVal:float = attribs[attr].total()
		var labelText = "attrib %s: %s" 
		var formatLabel = labelText % [attr,attribVal]
		attribLabel.text = formatLabel
		
		attrLabels[attr] = attribVal
		
		add_child(attribLabel)



 #func _process(delta: float):
	#pass
	##for attr in 
