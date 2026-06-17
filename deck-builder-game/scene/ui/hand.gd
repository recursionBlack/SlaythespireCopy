class_name Hand
extends HBoxContainer
# 手牌区

const CARD_UI_SCENE := preload("res://scene/card_ui/card_ui.tscn")

@export var player: Player
@export var char_stats: CharacterStats


func add_card(card: Card) -> void:
	var new_card_ui := CARD_UI_SCENE.instantiate()
	add_child(new_card_ui)
	new_card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
	new_card_ui.card = card
	new_card_ui.parent = self
	new_card_ui.char_stats = char_stats
	new_card_ui.player_modifiers = player.modifier_handler


func discard_card(card: CardUI) -> void:
	card.queue_free()


# 防止在弃牌过程中，玩家与卡牌交互
func disable_hand() -> void:
	for card in get_children():
		card.disabled = true


func _on_card_ui_reparent_requested(child: CardUI) -> void:
	child.disabled = true
	child.reparent(self)
	var new_index := clampi(child.orginal_index, 0, get_child_count())
	move_child.call_deferred(child, new_index)
	child.set_deferred("disabled", false)
