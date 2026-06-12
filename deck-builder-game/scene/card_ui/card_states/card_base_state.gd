extends CardState


func enter() -> void:
	# 所有子节点准备完成后，才会准备根节点，所以要等待根节点准备完成
	if not card_ui.is_node_ready():
		await  card_ui.ready
	
	if card_ui.tween and card_ui.tween.is_running():
		card_ui.tween.kill()
	
	card_ui.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)
	card_ui.reparent_requested.emit(card_ui)
	# 旋转中心偏移量，防止拖动卡片时，卡片的左上角跟随鼠标位置
	card_ui.pivot_offset = Vector2.ZERO


func on_gui_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("left_mouse"):
		# 将卡牌跟随鼠标的位置设置为鼠标点击时在卡牌的位置，而非卡牌的左上角
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		transition_requested.emit(self, CardState.State.CLICKED)


func on_mouse_entered() -> void:
	card_ui.panel.set("theme_override_styles/panel", card_ui.HOVER_STYLEBOX)


func on_mouse_exited() -> void:
	card_ui.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)
