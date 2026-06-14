extends Node
class_name Run

const BATTLE_SCENE := preload("res://scene/battle/battle.tscn")
const BATTLE_REWARD_SCENE := preload("res://scene/battle_rewards/battle_rewards.tscn")
const CAMPFIRE_SCENE := preload("res://scene/campfire/campfire.tscn")
const MAP_SCENE := preload("res://scene/map/map.tscn")
const SHOP_SCENE := preload("res://scene/shop/shop.tscn")
const TREASURE_SCENE := preload("res://scene/treasure/treasure.tscn")

@export var run_startup: RunStartup

@onready var current_view: Node = $CurrentView
@onready var deck_btn: CardPileOpener = %DeckBtn
@onready var deck_view: CardPileView = %DeckView

@onready var battle_btn: Button = %BattleBtn
@onready var campfire_btn: Button = %CampfireBtn
@onready var map_btn: Button = %MapBtn
@onready var rewards_btn: Button = %RewardsBtn
@onready var shop_btn: Button = %ShopBtn
@onready var treasure_btn: Button = %TreasureBtn

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
	_setup_event_connections()
	_setup_top_bar()
	print("TODO: procedurally generate map")


func _change_view(scene: PackedScene) -> void:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)


func _setup_event_connections() -> void:
	Events.battle_won.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	Events.battle_reward_exited.connect(_change_view.bind(MAP_SCENE))
	Events.map_exited.connect(_on_map_exited)
	Events.campfire_exited.connect(_change_view.bind(MAP_SCENE))
	Events.shop_exited.connect(_change_view.bind(MAP_SCENE))
	Events.treasure_room_exited.connect(_change_view.bind(MAP_SCENE))
	
	battle_btn.pressed.connect(_change_view.bind(BATTLE_SCENE))
	campfire_btn.pressed.connect(_change_view.bind(CAMPFIRE_SCENE))
	map_btn.pressed.connect(_change_view.bind(MAP_SCENE))
	rewards_btn.pressed.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	shop_btn.pressed.connect(_change_view.bind(SHOP_SCENE))
	treasure_btn.pressed.connect(_change_view.bind(TREASURE_SCENE))


func _setup_top_bar()-> void:
	print(character)
	print(character.deck)
	deck_btn.card_pile = character.deck
	deck_view.card_pile = character.deck
	deck_btn.pressed.connect(deck_view.show_current_view.bind("Deck"))

func _on_map_exited() -> void:
	print("TODO: from the MAP, change view based on room type")
