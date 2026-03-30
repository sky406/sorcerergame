extends Node

func _ready():

    var note = load("res://journal/data/claire_first_enemy.tres")

    print("ID:", note.id)
    print("Title:", note.title)
    print("Text:", note.body_text)