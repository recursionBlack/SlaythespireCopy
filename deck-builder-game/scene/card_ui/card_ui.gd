extends Control
class_name CardUI

# 拖拽卡片时，重新指定其父节点
signal reparent_requested(which_card_ui: CardUI)

const BASE_STYLEBOX := preload("uid://bd7cnl6r26ikp")
const DRAG_STYLEBOX := preload("uid://g5h276x8d4d4")
const HOVER_STYLEBOX := preload("uid://bpowp4huwkv4o")

@export var card: Card: set = _set_card

@onready var panel: Panel = $Panel
@onready var cost: Label = $Cost
@onready var icon: TextureRect = $Icon
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var targets: Array[Node] = []

var parent: Control
var tween: Tween

func _ready() -> void:
	card_state_machine.init(self)


func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)


# 设置过渡和缓动
func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)


func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()


func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()


func _set_card(value: Card) -> void:
	if not is_inside_tree():
		await  ready
	
	card = value
	cost.text = str(card.cost)
	icon.texture = card.icon

func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)


func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)
