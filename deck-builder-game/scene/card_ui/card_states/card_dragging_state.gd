extends CardState


func enter() -> void:
	# 使用组名查找BattleUI，然后将当前拖拽的卡牌的父节点指向它
	var ui_layer := get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		card_ui.reparent(ui_layer)
	
	card_ui.color.color = Color.NAVY_BLUE
	card_ui.state.text = "DRAGGING"


func on_input(_event: InputEvent) -> void:
	var mouse_motion := _event is InputEventMouseMotion
	# 右键按下 = 取消
	var cancel = _event.button_index == MOUSE_BUTTON_RIGHT and _event.pressed
	# 左键按下 / 左键抬起
	var confirm_press = _event.button_index == MOUSE_BUTTON_LEFT and _event.pressed
	var confirm_release = _event.button_index == MOUSE_BUTTON_LEFT and !_event.pressed
	var confirm = confirm_release or confirm_press
	if mouse_motion:
		card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset
	
	if cancel:
		transition_requested.emit(self, CardState.State.BASE)
	elif confirm:
		# 将输入标记为已处理, 以免意外的立即拾取新的卡片
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
