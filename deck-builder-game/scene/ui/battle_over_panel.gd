extends Panel
class_name BattleOverPanel


enum Type {WIN, LOSE}

@onready var label: Label = %Label
@onready var continue_btn: Button = %ContinueBtn
@onready var restart_btn: Button = %RestartBtn


func _ready() -> void:
	continue_btn.pressed.connect(
		func():
			Events.battle_won.emit()
	)
	restart_btn.pressed.connect(get_tree().reload_current_scene)
	Events.battle_over_screen_requested.connect(show_screen)


func show_screen(text: String, type: Type) -> void:
	label.text = text
	continue_btn.visible = type == Type.WIN
	restart_btn.visible = type == Type.LOSE
	show()
	get_tree().paused = true
