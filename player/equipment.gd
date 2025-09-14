extends Node
class_name Equipment
# important singals, do not delete
signal equipItem(item)
signal unequipItem(item)
signal slotfull(slot,item)

@export var testSlot:equipSlot
