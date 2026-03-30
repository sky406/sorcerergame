extends Node3D

# Preload your journal notes
var claire_note = preload("res://journal/data/claire_notes/first_enemy_encounter.tres")
var tower_note = preload("res://journal/data/adventurer_notes/ruined_tower.tres")

# Simple journal storage
var revealed_notes = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("=== Testing Journal System (3D Scene) ===")
	
	# Simulate discovering an enemy
	reveal_note(claire_note)
	
	# Simulate finding a note in the world
	reveal_note(tower_note)
	
	# Print all revealed notes
	print("\nAll revealed notes:")
	for note in revealed_notes:
		print("-", note.title)


# Function to reveal notes
func reveal_note(note: JournalNote):
	if not note.revealed:
		note.revealed = true
		print("New journal entry revealed:", note.title)
		print("ID: ", note.id)
		print("Author: ", note.author)
		print("Category: ", note.category)
		print("Body: ", note.body_text)
		print("Priority: ", note.priority, "\n")

	revealed_notes.append(note)

# Called every frame (not needed for this test)
func _process(delta: float) -> void:
	pass
