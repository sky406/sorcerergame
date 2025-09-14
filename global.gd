extends Node
const damlabel = preload("res://mobs/components/damage numbers/damageLabel.tscn")

func sumarray(array):
	var sum = 0 
	for i in array: 
		sum+=i
	return sum

func keyFromArray(key,array):
	#this is just simply a function for my bs way of storing dictionaries in arrays
#basically it gets the dictionarry from an array of dictionaries 
# TODO make this more specific
	for i in array: 
		if i.keys()[0]==key: return i
	print("key not found")

# func arraydictcontaining(key,array):
# 	pass
	# basically an improved versionof the key from array function that just  gives you all dictionaries containing a specific key
func rgbTocol(r:int,g:int,b:int):
	var R = r/255.0
	var G = g/255.0
	var B = b/255.0 
	return Color(R,G,B)

func randsign(num:float):
	#returns a random number of whatever sign
	const signs = ["+","-"]
	var s = signs[randi()%signs.size()]
	match  s:
		"+":
			return randf()*num
		"-":
			return randf()*num*-1

func displayDamage(
text:String="damage?",
position:Vector3 = Vector3.ZERO,
launchPower:float= 1.0,
col:Color = Color(1,1,1),
animSpeed:float=1.0,
angleSpread:float=1.0,
spawnSpread:float=0,
grav:float=30,
isCritical:bool = false,
critCol:Color = rgbTocol(255,48,61),
subText:String="",
subCol:Color = rgbTocol(171,178,187)
):
	var number = damlabel.instantiate()
	number.displaytext = text
	number.col = col
	number.position = position
	number.position.x+= randf_range(-spawnSpread,spawnSpread)
	number.position.y+= randf_range(-spawnSpread,spawnSpread)
	number.position.z+= randf_range(-spawnSpread,spawnSpread)
	number.xspeed = randf_range(-angleSpread,angleSpread)
	number.zspeed = randf_range(-angleSpread,angleSpread)
	number.yspeed = launchPower
	number.dropspeed=grav
	number.animspeed = animSpeed
	number.subtext = subText
	if isCritical:
		number.criticaltext = "CRITICAL HIT"
		number.critcol = critCol
	
	number.subtext = subText
	number.subcol = subCol

	call_deferred("add_child",number)

func isPlayer(body:Node3D):
	return body.is_in_group("player")

func findPlayer():
	return get_tree().get_first_node_in_group("player")
