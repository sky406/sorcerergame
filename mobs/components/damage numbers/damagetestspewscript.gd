extends Node3D
@onready var dicenumber = $"../../Control/VBoxContainer/HBoxContainer/dice_number"
@onready var dietype = $"../../Control/VBoxContainer/HBoxContainer/dietype"
@onready var dk = $"../../Control/VBoxContainer/dropOrKeep"

@onready var rrswitch = $"../../Control/VBoxContainer/HBoxContainer2/reroll"
@onready var rrtrigger = $"../../Control/VBoxContainer/HBoxContainer2/rerollTrigger"
@onready var rrtype = $"../../Control/VBoxContainer/HBoxContainer5/rrtype"

@onready var explodeswitch = $"../../Control/VBoxContainer/HBoxContainer3/explode"
@onready var explodetrigger = $"../../Control/VBoxContainer/HBoxContainer3/explode trigger"
@onready var explodeonce = $"../../Control/VBoxContainer/HBoxContainer4/once"
@onready var explodeall = $"../../Control/VBoxContainer/HBoxContainer4/alldice"
@onready var explodetype = $"../../Control/VBoxContainer/HBoxContainer4/HBoxContainer6/explodetype"
#const die = preload("res://player/items/weapons/weapon components/scripts/die.gd")

func get_popup_text(popup:MenuButton):
	var popupindex = popup.get_popup().get_focused_item()
	print(popupindex)
	return popup.get_popup().get_item_text(popupindex)
# NOTE TO SELF POP MENU BUTTONS SUCK

func _on_button_pressed():
	# this is just to selecte whether or nto to use greater or less than for reroll or explode
	var selectedrrtype = rrtype.get_selected_id()
	var selectedexplodetype = explodetype.get_selected_id()
	var selecteddrop = dk.get_selected_id()
	#print(selectedexplodetype)
	#print(selectedrrtype)
	#var rrt = 0
	#var ext = 0 
	#match  selectedexplodetype:
		#0:
			#ext = 0 
		#1:
			#ext = 1
		#2: 
			#ext = -1
#
	#match  selectedrrtype:
		#0: 
			#rrt = 0
		#1: 
			#rrt = 1
		#2:
			#rrt = -1
	# actually seting up the die
	var damagedie:Die =Die.new()
	#die.new(
		#int(dicenumber.text),
		#int(dietype.text),
		#kh.button_pressed,
		#kl.button_pressed,
		#dh.button_pressed,
		#dl.button_pressed,
			#[rrswitch.button_pressed,int(rrtrigger.text),rrt],
			#[explodeswitch.button_pressed,int(explodetrigger.text),ext],
		#explodeall.button_pressed,
		#explodeonce.button_pressed
	#)
	damagedie.numdice = int(dicenumber.text)
	damagedie.dietype = int(dietype.text)
	damagedie.keepOrDrop = selecteddrop
	damagedie.rerollDice = rrswitch.button_pressed
	damagedie.rerollTrigger = int(rrtrigger.text)
	damagedie.rerollHigherLower = selectedrrtype
	damagedie.explodeDice = explodeswitch.button_pressed
	damagedie.explodeTrigger = int(explodetrigger.text)
	damagedie.explodeTriggerHigherLower = selectedexplodetype
	damagedie.explodeAll = explodeall.button_pressed
	damagedie.explodeOnce = explodeonce.button_pressed
	print(damagedie)
	

	var roll = damagedie.roll()
	for i in roll:
		Global.displayDamage(
			str(i),
			position,
			10,
			Color.WHEAT,
			2,
			0.9,
			0,
			45
		)
#TODO make the die rolls easier to read
