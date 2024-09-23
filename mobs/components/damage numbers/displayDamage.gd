extends Node
const damlabel = preload("res://mobs/components/damage numbers/damageLabel.tscn")
func rgbTocol(r:int,g:int,b:int):
	var R = r/255.0
	var G = g/255.0
	var B = b/255.0 
	return Color(R,G,B)

func randsign(num:float):
	#returns a random number of whatever sign
	const signs = ["+","-"]
	var sign = signs[randi()%signs.size()]
	match  sign:
		"+":
			return randf()*num
		"-":
			return randf()*num*-1

func display(
text:String,
position:Vector3,
launchpower:float,
col:Color,
animspeed:float=1.0,
anglespread:float=1.0,
spawnspread:float=0,
grav:float=30,
isCritical:bool = false,
critcol = rgbTocol(255,48,61),
subtext:String="",
subcol = rgbTocol(171,178,187)
):
	var number = damlabel.instantiate()
	number.displaytext = text
	number.col = col
	number.global_position = position
	number.position.x+= randsign(spawnspread)
	number.position.y+= randsign(spawnspread)
	number.xspeed = randsign(anglespread)
	number.zspeed = randsign(anglespread)
	number.yspeed = launchpower
	number.dropspeed=grav
	number.animspeed = animspeed
	number.subtext = subtext
	if isCritical:
		number.criticaltext = "CRITICAL HIT"
		number.critcol = critcol
	
	number.subtext = subtext
	number.subcol = subcol

	call_deferred("add_child",number)
	
