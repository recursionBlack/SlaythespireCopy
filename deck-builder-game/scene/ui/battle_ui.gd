extends CanvasLayer
class_name BattleUI


@export var char_stats: CharacterStats: set = _set_char_stats

@onready var hand: Hand = $Hand
@onready var mana_ui: ManaUI = $ManaUI as ManaUI
@onready var end_turn_btn: Button = %EndTurnBtn


func _ready() -> void:
	Events.player_hand_drawn.connect(_on_player_hand_drawn)
	end_turn_btn.pressed.connect(_on_end_turn_button_pressed)

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	mana_ui.char_stats = char_stats
	hand.char_stats = char_stats


# 每回合抽完牌时，才放开endturn按钮，防止在抽牌过程中按下
func _on_player_hand_drawn() -> void:
	end_turn_btn.disabled = false


# endturn按下后，直到抽牌结束时，才会再次放开
func _on_end_turn_button_pressed() -> void:
	end_turn_btn.disabled = true
	Events.player_turn_ended.emit()
