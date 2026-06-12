extends CardState

const DRAG_MINIMUM_THRESHOLD := 0.05

var minimum_drag_time_elapsed := false

func enter() -> void:
	# 使用组名查找BattleUI，然后将当前拖拽的卡牌的父节点指向它
	var ui_layer := get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		card_ui.reparent(ui_layer)
	
	card_ui.panel.set("theme_override_styles/panel", card_ui.DRAG_STYLEBOX)
	Events.card_drag_started.emit(card_ui)
	
	minimum_drag_time_elapsed = false
	var threshold_timer := get_tree().create_timer(DRAG_MINIMUM_THRESHOLD, false)
	threshold_timer.timeout.connect(func(): minimum_drag_time_elapsed = true)


func exit() -> void:
	Events.card_drag_ended.emit(card_ui)


func on_input(_event: InputEvent) -> void:
	var single_targeted := card_ui.card.is_single_targeted()
	var mouse_motion := _event is InputEventMouseMotion
	var cancel = _event.is_action_pressed("right_mouse")
	# 左键按下 / 左键抬起
	var confirm = _event.is_action_released("left_mouse") or _event.is_action_pressed("left_mouse")
	if single_targeted and mouse_motion and card_ui.targets.size() > 0:
		transition_requested.emit(self, CardState.State.AIMING)
		return
	
	if mouse_motion:
		card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset
	
	if cancel:
		transition_requested.emit(self, CardState.State.BASE)
	elif minimum_drag_time_elapsed and confirm:
		# 将输入标记为已处理, 以免意外的立即拾取新的卡片
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
