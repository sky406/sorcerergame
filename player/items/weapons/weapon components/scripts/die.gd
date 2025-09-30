extends Resource
class_name Die
enum kldl{none,keepHighest,keepLowest,dropHighest,dropLowest}
enum highlow{exact,higher,lower}
@export var numdice:int
@export var dietype:int

@export_group("additional settings")
@export var keepOrDrop:kldl
@export var rerollDice:bool
@export var rerollTrigger:int
@export var rerollHigherLower:highlow = highlow.exact
@export var explodeDice:bool
@export var explodeTrigger:int
@export var explodeTriggerHigherLower:highlow = highlow.exact
@export var explodeAll:bool
@export var explodeOnce:bool = true
@export var exlimit = 10 #this exists for performance reasons try not to let it go on forever

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
func reroll(rolls:Array,trigger:int,highOrLow:highlow):

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
			2:
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
func explode(rolls:Array,trigger:int,highOrLow:highlow,once:bool=false,alldice:bool=false):
	var dicerolled= 1
	var explodecount = 0
	if alldice:
		dicerolled= numdice
	match highOrLow:
		2:
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
func rolldice(rolltimes:int,die:int)->Array:
	var results = []
	for i in range(rolltimes):
		results.append((randi()%die)+1)
	return results

func roll()->Array:
	# ):
	var rolls = rolldice(numdice,dietype)
	if reroll:
		rolls = reroll(rolls,rerollTrigger,rerollHigherLower)

	if explodeDice:
		rolls = explode(rolls,explodeTrigger,explodeTriggerHigherLower,explodeOnce,explodeAll)

	match keepOrDrop:
		1:
			rolls = keepHighest(rolls)
		2:
			rolls = keepLowest(rolls)
		3:
			rolls = dropHighest(rolls)
		4: 
			rolls = dropLowest(rolls)
	return rolls

#func _init(
	#num:int=1,
	#die:int=20,
#) -> void:
	#pass
