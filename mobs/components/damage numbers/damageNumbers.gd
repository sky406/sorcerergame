extends Node

func display_number(value:int,position:Vector2,type:String = "physical"):
	#TODO CHECK IF THIS SHOULD BE A VECTOR3
	var number = Label.new()
	number.global_position = position
	number.text = str(value)
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	
	var color = "#FFF"
	# note to self change this later
	
	number.label_settings.font_color = color
	number.label_settings.font_size = 18
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 1
	
	call_deferred("add_child",number)
	
	await number.resized
	
	number.pivot_offset = Vector2(number.size/2)
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number,"position:y", number.position.y-24,0.25
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		number, "position:y", number.position.y, 0.5
	).set_ease(Tween.EASE_IN).set_delay(0.25)
	# the delay is just to prevent overlap
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.5)
	
	await tween.finished
	number.queue_free()
