extends Node

var revealed_notes: Array[JournalNote] = []

func reveal_note(note: JournalNote):

	if note in revealed_notes:
		return

	note.revealed = true
	revealed_notes.append(note)

	print("New journal entry revealed:", note.title)
