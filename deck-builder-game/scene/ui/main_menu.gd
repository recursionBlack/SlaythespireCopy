extends Control

const CHAR_SELECTOR_SCENE := preload("res://scene/ui/character_selector.tscn")
const RUN_SCENE = preload("res://scene/run/run.tscn")

@export var run_startup: RunStartup

@onready var continue_btn: Button = %Continue
@onready var new_run: Button = $VBoxContainer/NewRun


func _ready() -> void:
	# 战斗结束面板会将paused设为true
	get_tree().paused = false
	continue_btn.disabled = SaveGame.load_data() == null


func _on_continue_pressed() -> void:
	run_startup.type = RunStartup.Type.CONTINUE_RUN
	get_tree().change_scene_to_packed(RUN_SCENE)


func _on_new_run_pressed() -> void:
	# 这里的场景转换太简单干脆了，可以自行添加更华丽的转场效果
	# 但本课程不会再次过多实现
	get_tree().change_scene_to_packed(CHAR_SELECTOR_SCENE)


func _on_exit_pressed() -> void:
	get_tree().quit()
