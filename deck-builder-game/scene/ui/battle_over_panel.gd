extends Panel
class_name BattleOverPanel

const MAIN_MENU = "res://scene/ui/main_menu.tscn"

enum Type {WIN, LOSE}

@onready var label: Label = %Label
@onready var continue_btn: Button = %ContinueBtn
@onready var main_menu_btn: Button = %MainMenuBtn


func _ready() -> void:
	continue_btn.pressed.connect(
		func():
			Events.battle_won.emit()
	)
	main_menu_btn.pressed.connect(get_tree().change_scene_to_file.bind(MAIN_MENU))
	Events.battle_over_screen_requested.connect(show_screen)


func show_screen(text: String, type: Type) -> void:
	label.text = text
	continue_btn.visible = type == Type.WIN
	main_menu_btn.visible = type == Type.LOSE
	show()
	get_tree().paused = true
