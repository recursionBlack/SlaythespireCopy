extends Resource
class_name RunStats

signal gold_changed

const STARTING_GOLD := 70

@export var gold := STARTING_GOLD: set = set_gold


func set_gold(new_value: int) -> void:
	gold = new_value
	gold_changed.emit()
