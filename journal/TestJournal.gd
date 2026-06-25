extends Node3D

var claire_note = preload("res://journal/data/claire_notes/first_enemy_encounter.tres")
var tower_note = preload("res://journal/data/adventurer_notes/ruined_tower.tres")

var journal := JournalManager.new()

func _ready():

	journal.reveal_note(claire_note)
	journal.reveal_note(tower_note)

	for note in journal.revealed_notes:
		print(note.title)
