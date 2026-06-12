extends CardState


func enter() -> void:
	# 在卡片ui的放置点检测器上，启用监控功能
	card_ui.drop_point_detector.monitoring = true


func on_input(_event: InputEvent) -> void:
	if _event is InputEventMouseMotion:
		transition_requested.emit(self, CardState.State.DRAGGING)
