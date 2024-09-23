extends Control
@onready var attributes = $"../attributes"
@onready var hpbar = $hp
@onready var hpval = $"hp/debug hp"
@onready var spriteholder = $"hp/effect sprite"
const effect_sprite = preload("res://effects/effect sprite.tscn")
var effecticons:Array = []
const iconlimit:int = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	hpbar.max_value = attributes.get_attribute("constitution")
	hpbar.value = attributes.hp
	hpval.text = str(attributes.hp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_attributes_attribute_changed(newattr):
	print("recalculating hp")
	hpbar.max_value = attributes.get_attribute("constitution")
	hpbar.value = attributes.hp
	hpval.text = str(attributes.hp)



func _on_attributes_effect_applied(effectName):
	print(effectName)


func _on_attributes_effect_added(effect):
	print(effect[0])
	print("beep beep")
	var effectproperties = effect[0]["properties"]
	var displayicon = Global.keyFromArray("display",effectproperties)["display"] 
	if displayicon:
		if effecticons.size()<iconlimit:
			var icon = Global.keyFromArray("icon",effectproperties)["icon"]
			var effect_icon = effect_sprite.instantiate()
			effect_icon.texture = ImageTexture.create_from_image(icon)
			effecticons.append(effect_icon)
			spriteholder.call_deferred("add_child",effect_icon)
		elif effecticons.size() == iconlimit:
			var icon = ImageTexture.create_from_image(Image.load_from_file("res://assets/placeholder sprites/placeholder empty effect-Recovered.png"))
			var effect_icon = effect_sprite.instantiate()
			effect_icon.texture = icon
			effecticons.append(effect_icon)
			spriteholder.call_deferred("add_child",effect_icon)
	
		
# note to self make the sprites more readable on release
#TODO make a function for removed effects
#this simply grabs the icon for the effect and adds it to the list 


func _on_attributes_effect_removed(effect):
	pass # Replace with function body.
