extends Node
class_name Effect
# @export var icon:Image = null
# @export var effectname = "template"
@onready var lifetimer = $lifetimer
@onready var interval = $intervaltimer
@export var effect:effectDat
# @export var targetAttribute:Node = null
#main properties
# var displayeffect:bool = false
# var timedeffect:bool = false
# var isstackable:bool = false
# var lifetime:float = 0
# var overtime:Dictionary = {"active":false,"interval":0,"effects":[]} 
# var effectOn=false
# var effect:Array = []
signal effect_timeout(effect)
signal effect_added(effect)
signal effect_removed(effect)
signal effect_interval_timeout(effect)
signal overtime_effect_timeout(effect)

# func get_EffectDetails():
# 	return [
# 		{"properties":
# 		[
# 			{"name":effectname},
# 			{"display":displayeffect},
# 			{"istimed":timedeffect},
# 			{"lifetime":lifetime},
# 			{"isstackable":isstackable},
# 			{"icon":icon}

# 		]	
# 		},
# 		{"effects":effect},
# 		#effect formats not all of these will work for normal effects
# 		# {"attribute":"strengh","value":-1,"limit":1} attribute change
# 		# {"damage":4} damage
# 		# {heal:3} heal
# 		# note, dice rolls are already applied when in effect form to make it easier
# 		{"overtime":overtime} 
# 	]

# func build_effect(Effect:Array):
# 	print("effect build in progress")
# 	for i in Effect:
# 		print(i.keys()[0])
# 		match i.keys()[0]:
# 			"properties":
# 				print("displaying properties")
# 				var props = i["properties"]
# 				for key in props:
# 					match key.keys()[0]:
# 						"name":
# 							print("name found: " + str(key["name"]) +" :)")
# 							effectname = key["name"]
# 						"display":
# 							print("displayeffect found")
# 							displayeffect = key["display"]
# 						"istimed":
# 							print("timedeffect found: value = "+ str(key["istimed"]))
# 							timedeffect = key["istimed"]
# 						"lifetime":
# 							print("lifetime found: value = " + str(key["lifetime"]))
# 							lifetime = key["lifetime"]
# 						"isstackable":
# 							print("stackable found: value = " + str(key["isstackable"]))
# 							isstackable = key["isstackable"]
# 						"icon":
# 							print("found icon")
# 							icon =  key["icon"]
# 			"effects":
# 				print("effects"+str(i["effects"]))
# 				effect = i["effects"]
# 			"overtime":
# 				print("overtime effects"+str(i["overtime"]))
# 				overtime =i["overtime"]

			


func get_Effect():return effect

func _ready():
	# if timedeffect:
	# 	lifetimer.wait_time = lifetime
	# 	lifetimer.start()
	# 	lifetimer.timeout.connect(effectend())
	
	# if overtime["active"]:
	# 	interval.wait_time = overtime["interval"]
	# 	interval.timeout.connect(_intervalend)
	# 	interval.start()
	if effect.isTimed:
		lifetimer.wait_time = effect.lifetime
		lifetimer.start()
	if effect.overtime:
		interval.wait_time = effect.overtimeInterval
		
		
func _intervalend():
	var overtimeNode = effect.overtimeEffect.instantiate()
	call_deferred("add_child",overtimeNode)
	

func effectend():
	effect_timeout.emit(effect)
	queue_free()

func getEffects():
	return effect

func _on_tree_exiting():
	effect_removed.emit(effect)
