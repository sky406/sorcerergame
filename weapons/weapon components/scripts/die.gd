extends Node

var numdice=0
var dietype=0
var modifiers = {}
func _init(
iterations,
die,
kh:bool = false,
kl:bool = false,
dh:bool = false,
dl:bool = false,
rr:Array=[false,0,0],
x:Array=[false,0,0],
ex:bool=false,
xo:bool=false):
	numdice = iterations
	dietype = die
	# keep highest keep lowest
	if kh and kl: print("warning kh and kl are on, the roll may not function as intended")
	if kh: modifiers["kh"]=true
	if kl: modifiers["kl"]=true
	#drop high/low
	if dh and dl: print("warning kh and kl are on, the roll may not function as intended")
	if dh: modifiers["dh"]=true
	if dl: modifiers["dl"]=true
	# reroll
	if rr[0]:modifiers["rr"]={"trigger":rr[1],"highOrLow":rr[2]}#-1 is low 1 is high, 0 is exact
	# explode
	var explode = {}
	if x[0]:
		explode["trigger"]=x[1]
		explode["highOrLow"]=x[2]# same as reroll
	if ex:
		explode["alldice"]=true
	if xo:
		explode["once"]=true
	if explode != {}:
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
func reroll(rolls:Array,trigger:int,higher:bool=false,lower:bool=false):
	# TODO adjust this to work with the modifiers new format
	var rerolled = []
	var mode = 0
	if higher:
		mode = 1
	elif lower:
		mode = -1
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
func explode(rolls:Array,trigger:int,highOrLow:int=0,once:bool=false,alldice:bool=false):
	var dicerolled= 1
	if alldice:
		dicerolled= numdice
	for i in rolls:
		match highOrLow:
			-1:
				if i <= trigger:
					var rerolled = rolldice(dicerolled,dietype)
					if !once:
						while rerolled[-1] <= trigger:
							rerolled.append_array(rolldice(dicerolled,dietype))
					rolls.append_array(rerolled)
			0:
				if i == trigger:
					var rerolled = rolldice(dicerolled,dietype)
					if !once:
						while rerolled[-1] == trigger:
							rerolled.append_array(rolldice(dicerolled,dietype))
					rolls.append_array(rerolled)
			1:
				if i >= trigger:
					var rerolled = rolldice(1,dietype)
					if !once:
						while rerolled[-1] >= trigger:
							rerolled.append_array(rolldice(1,dietype))
					rolls.append_array(rerolled)						
func rolldice(rolltimes:int,die:int):
	var results = []
	for i in range(rolltimes-1):
		results.append((randi()%die)+1)
	return results

func roll():
	var rolls = rolldice(numdice,dietype)
	if modifiers.is_empty():
		return rolls

	
	
