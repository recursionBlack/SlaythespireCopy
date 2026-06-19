class_name RelicControl
extends Control

const RELICS_PER_PAGE := 5
const TWEEN_SCROLL_DURATION := 0.2

@export var left_btn: TextureButton
@export var right_btn: TextureButton

@onready var relics: HBoxContainer = %Relics
@onready var page_width = self.custom_minimum_size.x

var num_of_relics := 0
var current_page := 1
var max_page := 0
var tween: Tween


func _ready() -> void:
	left_btn.pressed.connect(_on_left_btn_pressed)
	right_btn.pressed.connect(_on_right_btn_pressed)
	
	# 删除测试时的占位符遗物
	for relic_ui: RelicUI in relics.get_children():
		# 准备阶段时，占位符要用free立即清理掉，不要用queue_free
		relic_ui.free()
	
	relics.child_order_changed.connect(_on_relics_child_order_changed)

func update() -> void:
	# 防止退出程序时，导致遗物子节点的释放也触发了update
	if not is_instance_valid(right_btn) or not is_instance_valid(left_btn):
		return
	
	num_of_relics = relics.get_child_count()
	max_page = ceili(num_of_relics / float(RELICS_PER_PAGE))
	
	left_btn.disabled = current_page <= 1
	right_btn.disabled = current_page >= max_page


func _tween_to(x_position: float) -> void:
	# 防止操作过快时，同时生成两个补间动画，
	if tween:
		tween.kill()
	
	tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(relics, "position:x", x_position, TWEEN_SCROLL_DURATION)


func _on_left_btn_pressed() -> void:
	if current_page > 1:
		current_page -= 1
		update()
		_tween_to(relics.position.x + page_width)


func _on_right_btn_pressed() -> void:
	if current_page < max_page:
		current_page += 1
		update()
		_tween_to(relics.position.x - page_width)


func _on_relics_child_order_changed() -> void:
	update()
