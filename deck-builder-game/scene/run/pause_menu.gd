class_name PausedMenu
extends CanvasLayer

signal save_and_quit

@onready var back_to_game_btn: Button = %BackToGameBtn
@onready var save_and_quit_btn: Button = %SaveAndQuitBtn


func _ready() -> void:
	back_to_game_btn.pressed.connect(_unpause)
	save_and_quit_btn.pressed.connect(_on_save_and_quit_btn_pressed)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if visible:
			_unpause()
		else:
			_pause()
		
		# 阻止esc输入，被继续向下传播
		get_viewport().set_input_as_handled()


func _pause() -> void:
	show()
	get_tree().paused = true


func _unpause() -> void:
	hide()
	get_tree().paused = false


func _on_save_and_quit_btn_pressed() -> void:
	get_tree()
	save_and_quit.emit()
