extends Node
class_name Run

const BATTLE_SCENE := preload("res://scene/battle/battle.tscn")
const BATTLE_REWARD_SCENE := preload("res://scene/battle_rewards/battle_rewards.tscn")
const CAMPFIRE_SCENE := preload("res://scene/campfire/campfire.tscn")
const SHOP_SCENE := preload("res://scene/shop/shop.tscn")
const TREASURE_SCENE := preload("res://scene/treasure/treasure.tscn")

@export var run_startup: RunStartup

@onready var map: Map = $Map
@onready var current_view: Node = $CurrentView
@onready var health_ui: HealthUI = %HealthUI
@onready var gold_ui: GoldUI = %GoldUI
@onready var relic_handler: RelicHandler = %RelicHandler
@onready var relic_tooltip: RelicTooltip = %RelicTooltip
@onready var deck_btn: CardPileOpener = %DeckBtn
@onready var deck_view: CardPileView = %DeckView

@onready var battle_btn: Button = %BattleBtn
@onready var campfire_btn: Button = %CampfireBtn
@onready var map_btn: Button = %MapBtn
@onready var rewards_btn: Button = %RewardsBtn
@onready var shop_btn: Button = %ShopBtn
@onready var treasure_btn: Button = %TreasureBtn

var stats: RunStats
var character: CharacterStats


func _ready() -> void:
	if not run_startup:
		return
	
	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			character = run_startup.picked_character.create_instance()
			_start_run()
		RunStartup.Type.CONTINUE_RUN:
			print("TODO: load previous Run")


func _start_run() -> void:
	stats = RunStats.new()
	
	_setup_event_connections()
	_setup_top_bar()
	map.generate_new_map()
	map.unlock_floor(0)


func _change_view(scene: PackedScene) -> Node:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)
	map.hide_map()
	
	return new_view


func _show_map() -> void:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	map.show_map()
	map.unlock_next_rooms()

func _setup_event_connections() -> void:
	Events.battle_won.connect(_on_battle_won)
	Events.battle_reward_exited.connect(_show_map)
	Events.map_exited.connect(_on_map_exited)
	Events.campfire_exited.connect(_show_map)
	Events.shop_exited.connect(_show_map)
	Events.treasure_room_exited.connect(_show_map)
	
	battle_btn.pressed.connect(_change_view.bind(BATTLE_SCENE))
	campfire_btn.pressed.connect(_change_view.bind(CAMPFIRE_SCENE))
	map_btn.pressed.connect(_show_map)
	rewards_btn.pressed.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	shop_btn.pressed.connect(_change_view.bind(SHOP_SCENE))
	treasure_btn.pressed.connect(_change_view.bind(TREASURE_SCENE))


func _setup_top_bar()-> void:
	character.stats_changed.connect(health_ui.update_stats.bind(character))
	health_ui.update_stats(character)
	gold_ui.run_stats = stats
	
	relic_handler.add_relic(character.starting_relic)
	Events.relic_tooltip_requested.connect(relic_tooltip.show_tooltip)
	
	deck_btn.card_pile = character.deck
	deck_view.card_pile = character.deck
	deck_btn.pressed.connect(deck_view.show_current_view.bind("Deck"))


func _on_battle_room_entered(room: Room) -> void:
	var battle_scene: Battle = _change_view(BATTLE_SCENE)
	battle_scene.char_stats = character
	battle_scene.battle_stats = room.battle_stats
	battle_scene.relics = relic_handler
	battle_scene.start_battle()


func _on_campfire_entered() -> void:
	var campfire := _change_view(CAMPFIRE_SCENE) as Campfire
	campfire.char_stats = character


func _on_shop_entered() -> void:
	var shop := _change_view(SHOP_SCENE) as Shop
	shop.char_stats = character
	shop.run_stats = stats
	shop.relic_handler = relic_handler
	Events.shop_entered.emit(shop)
	shop.populate_shop()


func _on_battle_won() -> void:
	var reward_scene := _change_view(BATTLE_REWARD_SCENE) as BattleReward
	reward_scene.run_stats = stats
	reward_scene.character_stats = character
	
	reward_scene.add_gold_reward(map.last_room.battle_stats.roll_gold_reward())
	reward_scene.add_card_reward()


func _on_map_exited(room: Room) -> void:
	match room.type:
		Room.Type.MONSTER:
			_on_battle_room_entered(room)
		Room.Type.TREASURE:
			_change_view(TREASURE_SCENE)
		Room.Type.CAMPFIRE:
			_on_campfire_entered()
		Room.Type.SHOP:
			_on_shop_entered()
		Room.Type.BOSS:
			_on_battle_room_entered(room)
