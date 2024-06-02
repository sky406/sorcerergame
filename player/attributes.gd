extends Node
const die = preload("res://weapons/weapon components/scripts/die.gd")
@export var strength:int = 8
@export var dexterity:int = 12
@export var constitution:int = 13
@export var inteligence:int = 11
@export var wisdom:int = 10
@export var charisma:int = 18
var energy:float = 2
func calculate_mod(attribute:int):
	return floor((attribute-10)/2)

# basic attributes
@export var level:int = 1
var prof_mod:int = ceil(level/4)+1 
var maxhp:int = 6 + calculate_mod(constitution) #(level-1 * (3 + calculate_mod(con)))
var hp:int = maxhp
var speed:float = 10 + calculate_mod(dexterity)
# damage stuff
@export var resistances:Array = []
@export var vulnerabilities:Array = []
@export var immunities:Array = []
@export var globaldamagebonus = 0

# effect stuff
var appliedEffects = {}

func _ready():
	print(maxhp)

func _process(delta):
	maxhp = 6+calculate_mod(constitution)
	

func applyeffect(effect):
	var 

func removeeffect(effect):
	pass
