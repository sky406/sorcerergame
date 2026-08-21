@tool
class_name HPbar
extends ProgressBar
@export_category("settings")
## the rate at which the top bar changes
@export var topBarRate:float = 0.05:
	set(value):
		topBarRate = value
		update_configuration_warnings()
## the rate at which the bottom bar changes
@export var bottomBarRate:float = 0.1:
	set(value):
		bottomBarRate = value
		update_configuration_warnings()


@onready var damageBar:ProgressBar = $damagebar
@onready var player:PlayerController = Global.findPlayer()

var hpValue:float
var barExtention:float = 0 

#region configuration warnings
func _get_configuration_warnings() -> PackedStringArray:
	var warning:PackedStringArray=[]
	
	if topBarRate < bottomBarRate:
		warning.append("bottom rate is higher than top rate \n bar may not look right")
	return warning
#endregion

func _ready() -> void:
	if player:
		var hp:HP = player.attributes.attributes["hp"]
		setMaxHP(hp.maxValue)
		

func _process(delta: float) -> void:
	if player:
		var hp:HP = player.attributes.attributes["hp"]
		hpValue = hp.value
	
	size.x = 100 + barExtention
	damageBar.size.x = 100 + barExtention
	if value!= damageBar.value:
		value = move_toward(value,damageBar.value,bottomBarRate)
	
	if damageBar.value != hpValue:
		damageBar.value = move_toward(damageBar.value,hpValue,topBarRate)


func setMaxHP(value:float):
	## sets the max hp for both bars
	max_value = value
	damageBar.max_value = value

#TODO change the damage bar class to allow messing the colors of the hp bar
#TODO make the bar extention auromated at somepoint
