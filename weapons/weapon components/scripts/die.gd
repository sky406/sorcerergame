extends Node

var numdice=0
var dietype=0
var exlimit = 10 #this exists for performance reasons try not to let it go on forever
var modifiers = {}
func _init(
iterations:int=1,
die:int=20,
kh:bool = false,
kl:bool = false,
dh:bool = false,
dl:bool = false,
rr:Array=[false,0,0],
x:Array=[false,0,0],
ex:bool=false,
xo:bool=false,
explodelimit=10
):
	numdice = iterations
	dietype = die
	exlimit = explodelimit
	# keep highest keep lowest
	if kh and kl: print("warning kh and kl are on, the roll may not function as intended")
	if kh: modifiers["kh"]=true 
	else: modifiers["kh"]=false

	if kl: modifiers["kl"]=true
	else: modifiers["kl"]=false

	#drop high/low
	if dh and dl: print("warning kh and kl are on, the roll may not function as intended")
	if dh: modifiers["dh"]=true
	else: modifiers["dh"]=false

	if dl: modifiers["dl"]=true
	else: modifiers["dl"]=false

	# reroll
	if rr[0]:modifiers["rr"]={"trigger":rr[1],"highOrLow":rr[2]}#-1 is low 1 is high, 0 is exact
	# explode
	var explode = {}
	if x[0]:
		explode["trigger"]=x[1]
		explode["highOrLow"]=x[2]# same as reroll
		if ex:
			explode["alldice"]=true
		else:
			explode["alldice"]= false
		if xo:
			explode["once"]=true
		else:
			explode["once"]= false
		modifiers["explode"] = explode
func dropLowest(rolls:Array):
	var lowest = rolls.min()
	rolls.erase(lowest)
	return rolls
func dropHighest(rolls:Array):
	var highest = rolls.max()
	rolls.erase(highest)
	return rolls
func keepLowest(rolls:Array):
	return [rolls.min()]
func keepHighest(rolls:Array):
	return [rolls.max()]
func reroll(rolls:Array,trigger:int,highOrLow:int=0):

	var rerolled = []
	var mode = highOrLow
	while rolls!=[]:
		match mode:
			0:
				if rolls[0]==trigger:
					rerolled.append(rolldice(1,dietype)[0])
				else :
					rerolled.append(rolls[0])
				
			1:
				if rolls[0]>=trigger:
					rerolled.append(rolldice(1,dietype)[0])
				else :
					rerolled.append(rolls[0])
			-1:
				if rolls[0]<=trigger:
					rerolled.append(rolldice(1,dietype)[0])
				else :
					rerolled.append(rolls[0])
		rolls.remove_at(0)
	return rerolled
func arrayHasGreaterEqual(array:Array,target:int):
	for i in array:
		if i >= target:
			return true
	return false
func arrayHasLessEqual(array:Array,target:int):
	for i in array:
		if i <= target:
			return true
	return false
func arrayHasEqual(array:Array,target:int):
	for i in array:
		if i == target:
			return true
	return false
func explode(rolls:Array,trigger:int,highOrLow:int=0,once:bool=false,alldice:bool=false):
	var dicerolled= 1
	var explodecount = 0
	if alldice:
		dicerolled= numdice
	match highOrLow:
		-1:
			if arrayHasLessEqual(rolls,trigger):
				var explodeddice = rolldice(dicerolled,dietype)
				explodecount+=1
				if not once:
					while explodecount < exlimit and arrayHasEqual(explodeddice,trigger):
						rolls.append_array(explodeddice)
						explodeddice = rolldice(dicerolled,dietype)
						explodecount+=1
				else:
					rolls.append_array(explodeddice)
		0:
			if arrayHasEqual(rolls,trigger):
				var explodeddice = rolldice(dicerolled,dietype)
				explodecount+=1
				if not once:
					while explodecount < exlimit and arrayHasEqual(explodeddice,trigger):
						rolls.append_array(explodeddice)
						explodeddice = rolldice(dicerolled,dietype)
						explodecount+=1
				else:
					rolls.append_array(explodeddice)
		1:
			if arrayHasGreaterEqual(rolls,trigger):
				var explodeddice = rolldice(dicerolled,dietype)
				explodecount+=1
				if not once:
					while explodecount < exlimit and arrayHasGreaterEqual(explodeddice,trigger):
						rolls.append_array(explodeddice)
						explodeddice = rolldice(dicerolled,dietype)
						explodecount+=1
				else:
					rolls.append_array(explodeddice)
	return rolls					
func rolldice(rolltimes:int,die:int):
	var results = []
	for i in range(rolltimes):
		results.append((randi()%die)+1)
	return results
func roll():
	print(modifiers)
	var rolls = rolldice(numdice,dietype)
	if modifiers.is_empty():
		return rolls

	if modifiers.has("rr"):
		var rrTrigger = modifiers["rr"]["trigger"]
		var rrhighlow = modifiers["rr"]["highOrLow"]
		rolls = reroll(rolls,rrTrigger,rrhighlow)

	if modifiers.has("explode"):
		var Explode = modifiers["explode"]
		print(Explode)
		rolls = explode(rolls,Explode["trigger"],Explode["highOrLow"],Explode["once"],Explode["alldice"])

	if modifiers["kh"]:
		rolls = keepHighest(rolls)
	elif modifiers["kl"]:
		rolls = keepLowest(rolls)
	
	if modifiers["dh"]:
		rolls = dropHighest(rolls)
	elif modifiers["dl"]:
		rolls = dropLowest(rolls)

	return rolls
