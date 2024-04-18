extends Node


# # Called when the node enters the scene tree for the first time.
# func _ready():
# 	pass # Replace with function body.


# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass

# #to determine damage dice damage rolls are split like this

# func calculate_damage(dice):
# 	pass

# func genmodifier(modType:String,triggerOn=-1):
# 	pass

# func gendice(numofdice:int,dietype:int,modifiers:Array=[]):

# 	var dice = {
# 		"dicenum":numofdice,
# 		"dietype":dietype,
# 		"modifiers":modifiers		
# 	}
# 	return dice

# func rolldice(dice:Dictionary):
# 	var modifiers:Array = dice.get("modifiers")
# 	var dicerolls:Array=[]
# 	for i in range(dice.get("dicenum")-1):
# 		dicerolls.append((randi() % dice.get("dietype"))+1)
	
# 	if modifiers.has("kh"):
# 		return [dicerolls.max()]
# 	elif modifiers.has("kl"):
# 		return [dicerolls.min()]
# 	else:
# 		pass
	


# # dice roll specific values
# func explode(dicearray,dice,big:bool=false):
# 	pass
	
# func drop(high:bool):
# 	pass

# func keep(high:bool):
# 	pass

# func Roll(roll:Dictionary):
# 	# first check if the roll is valid
# 	# assume the toll string is something like this {"roll":1d10,'mods':[kh,kl,{x,2},ex]}
# 	var rolls = []
# 	if roll.has("roll"):
# 		var dice = roll.get("roll")
# 		for i in dice:
# 			if i.is_valid_int():
# 				pass
	
func texttoroll(dieroll:String):	
	var rolledDice = []
	var  total = 0
	var interations = ""
	var die = ""
	var modifier = ""
	var mode = 0
	# modes 0= iterations, 1 = die, 2= modifier
	if dieroll.begins_with("d"):
		mode = 1
		interations = "1"
	# for i in dieroll:
	# 	match mode:
	# 		0:
	# 			match i:

	# 				"d":
	# 					mode=1
	# 				_:
	# 					if i.is_valid_int():
	# 						interations+=i
	# 						dieroll = dieroll.right(0)
	# 						#remove the first character
	# 						print(dieroll)
	# 		1:
	# 			if i.is_valid_int():
	# 				die+=i
	# 			elif dieroll.begins_with("dl"):
					
	while  dieroll !="":
		match mode:
			0:
				if dieroll[0].is_valid_int():
					interations+=dieroll[0]
					dieroll = dieroll.right(0)
				elif dieroll[0] == "d":
					mode = 1
					dieroll = dieroll.right(0)
				else:
					dieroll= dieroll.right(0)
			1:
				if dieroll[0].is_valid_int():
					die+=dieroll[0]
					dieroll =dieroll.right(0)
				else:
					match dieroll[0]:
						"x":
							# shit i just realized this accounts for only one number 
							
							if dieroll[1].is_valid_int():
								rolledDice = roll(int(interations),int(die))
								for i in rolledDice:
									if i == int(dieroll[1]):
										rolledDice.append(roll(1,int(die))[0])
							elif dieroll[1] in ["<",">"]:
								rolledDice = roll(int(interations),int(die))
								for i in rolledDice:
									match dieroll[1]:
										"<":
											if i <= int(dieroll[2]):
												rolledDice.append(roll(1,int(die))[0])
										">":
											if i >= int(dieroll[2]):
												rolledDice.append(roll(1,int(die))[0])
							
								

func roll(iterations,die):
	var results = []
	for i in range(iterations-1):
		results.append((randi()%die)+1)
	return results

func sumarray(array):
	var sum = 0
	for i in array:
		sum+=i
	return sum
