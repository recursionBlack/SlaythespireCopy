extends Node
# 每回合要做的事
class_name PlayerHandler

# 回合开始时，每张卡开抽间的动画间隔，避免所有卡一下出现在手牌区
const HAND_DRAW_INTERVAL := 0.25
# 回合结束时，每张牌逐个丢弃时的动画间隔，避免手牌区所有卡一下被清空
const HAND_DISCARD_INTERVAL := 0.25

@export var hand: Hand

var character: CharacterStats


func _ready() -> void:
	Events.card_played.connect(_on_card_played)

func start_battle(char_stats: CharacterStats) -> void:
	character = char_stats
	# 战斗开始时，初始化抽牌堆，洗牌，初始化弃牌堆
	character.draw_pile = character.deck.duplicate(true)
	character.draw_pile.shuffle()
	character.discard = CardPile.new()
	start_turn()


func start_turn() -> void:
	character.block = 0
	character.reset_mana()
	draw_cards(character.cards_per_turn)


func end_turn() -> void:
	
	hand.disable_hand()
	discard_cards()

func draw_card() -> void:
	reshuffle_deck_from_discard()
	hand.add_card(character.draw_pile.draw_card())
	reshuffle_deck_from_discard()


func draw_cards(amount: int) -> void:
	var tween := create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)
	
	tween.finished.connect(func(): Events.player_hand_drawn.emit())


func discard_cards() -> void:
	var tween := create_tween()
	for card_ui: CardUI in hand.get_children():
		tween.tween_callback(character.discard.add_card.bind(card_ui.card))
		tween.tween_callback(hand.discard_card.bind(card_ui))
		tween.tween_interval(HAND_DISCARD_INTERVAL)
	
	tween.finished.connect(
		func():
			Events.player_hand_discarded.emit()
	)


# 重新洗牌
func reshuffle_deck_from_discard() -> void:
	if not character.draw_pile.empty():
		return
	
	while not character.discard.empty():
		character.draw_pile.add_card(character.discard.draw_card())
	
	character.draw_pile.shuffle()


func _on_card_played(card: Card) -> void:
	character.discard.add_card(card)
