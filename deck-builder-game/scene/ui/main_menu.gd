extends Control

@onready var continue_btn: Button = %Continue
@onready var new_run: Button = $VBoxContainer/NewRun


func _ready() -> void:
	# 战斗结束面板会将paused设为true
	get_tree().paused = false


func _on_continue_pressed() -> void:
	print("Continue Run")


func _on_new_run_pressed() -> void:
	print("New Run")


func _on_exit_pressed() -> void:
	get_tree().quit()
