extends Area3D

@export var note: JournalNote

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):

	if body.is_in_group("player"):
		JournalManager.reveal_note(note)
		queue_free()
