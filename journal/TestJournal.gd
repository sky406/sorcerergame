extends Node3D

var claire_note = preload("res://journal/data/claire_notes/first_enemy_encounter.tres")
var tower_note = preload("res://journal/data/adventurer_notes/ruined_tower.tres")

func _ready():

	JournalManager.reveal_note(claire_note)
	JournalManager.reveal_note(tower_note)

	for note in JournalManager.revealed_notes:
		print(note.title)
