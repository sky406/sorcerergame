extends Control
@onready var hpBar:ProgressBar = $healthbar/damagebar
@onready var damageBar:ProgressBar = $healthbar
@export var damageBarDrainSpeed:float = 1.5

@onready var player:PlayerController = Global.findPlayer()

func _ready() -> void:
	hpBar.value = hpBar.max_value
	damageBar.max_value = hpBar.max_value
	damageBar.value = damageBar.max_value
	
	if player:
		player.damageTaken.connect(damagehp)
		var playerAttribs:Attributes = player.attributes
		var playerhp:HP = playerAttribs.attributes["hp"]
		hpBar.max_value = playerhp.maxValue
		hpBar.value = playerhp.value
		
		damageBar.max_value = hpBar.max_value
		damageBar.value = hpBar.value
	
	
	
func setMaxHp(value:float):
	damageBar.max_value = value
	hpBar.max_value = value
	
func _process(delta: float) -> void:
	if damageBar.value != hpBar.value:
		damageBar.value = move_toward(damageBar.value,hpBar.value,damageBarDrainSpeed)

func damagehp (ammount) -> void:
	## increase or reduce the hp value but the ammount
	print_debug(ammount)
	print_debug(hpBar.value)
	hpBar.value -= ammount
