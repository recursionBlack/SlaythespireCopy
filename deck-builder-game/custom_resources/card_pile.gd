extends Resource
class_name CardPile

signal card_pile_size_changed(cards_amount: int)

@export var cards: Array[Card] = []


func empty() -> bool:
	return cards.is_empty()


# 抽牌
func draw_card() -> Card:
	var card = cards.pop_front()
	card_pile_size_changed.emit(cards.size())
	return card


func add_card(card: Card):
	cards.append(card)
	card_pile_size_changed.emit(cards.size())


# 洗牌
func shuffle() -> void:
	RNG.array_shuffle(cards)


func clear() -> void:
	cards.clear()
	card_pile_size_changed.emit(cards.size())


# We need this method because of a Godot issue
# reported here:
# https://github.com/godotengine/godot/issues/74918
func duplicate_cards() -> Array[Card]:
	var new_array: Array[Card] = []
	
	for card: Card in cards:
		new_array.append(card.duplicate())
	
	return new_array


# 自己手动实现深拷贝，以避免godot引擎，目前对数组中，
# 仅对数组本身深拷贝，但对数组元素浅拷贝的问题
func custom_duplicate() -> CardPile:
	var new_card_pile := CardPile.new()
	new_card_pile.cards = duplicate_cards()
	
	return new_card_pile

func _to_string() -> String:
	var _card_strings: PackedStringArray = []
	for i in range(cards.size()):
		_card_strings.append("%s: %s" % [i+1, cards[i].id])
	
	return "\n".join(_card_strings)
