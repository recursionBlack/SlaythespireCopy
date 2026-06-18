extends Stats
class_name CharacterStats

@export_group("Visuals")
@export var charactor_name: String
@export_multiline var description: String
@export var portrait: Texture

@export_group("Gameplay Data")
# 初始牌堆，每回合抽牌数，最大法力值
@export var starting_deck: CardPile
@export var draftable_cards: CardPile
@export var cards_per_turn: int
@export var max_mana :int
@export var starting_relic: Relic

var mana: int :set = set_mana
# 总卡组，弃牌堆，抽牌堆
var deck: CardPile
var discard: CardPile
var draw_pile: CardPile


func set_mana(value: int) -> void:
	mana = value
	stats_changed.emit()


# 每回合开始时被调用
func reset_mana() -> void:
	mana = max_mana


func take_damage(damage: int) -> void:
	var initial_health := health
	super.take_damage(damage)
	if initial_health > health:
		Events.player_hit.emit()


func can_play_card(card: Card) -> bool:
	return mana >= card.cost


func create_instance() -> Resource:
	var instance: CharacterStats = duplicate()
	instance.health = max_health
	instance.block = 0
	instance.reset_mana()
	instance.deck = instance.starting_deck.duplicate()
	print("方法1 - deck 是否为 null: ", instance.deck == null)
	instance.draw_pile = CardPile.new()
	instance.discard = CardPile.new()
	
	return instance
