extends Node

func applytoactor(actor,effect):
	if actor.has("attributes"):
		actor.attibutes.addEffect(effect)
	
