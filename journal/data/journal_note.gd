# journal/data/journal_note.gd
extends Resource
class_name JournalNote

@export var id: String
@export var title: String
@export_multiline var body_text: String

@export var author: String = "Claire"
@export var category: String = "general"

@export var icon: Texture2D
@export var revealed: bool = false


# Optional metadata (future-proofing)
@export var related_entity_id: String = ""   # enemy, npc, item, location id
@export var world_location_id: String = ""   # zone/area identifier
@export var priority: int = 0                # sorting / UI emphasis
