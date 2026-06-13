extends EnemyAction

@export var damage := 7


func perform_action() -> void:
	if not enemy or not target:
		return
	
	# 缓动动画变量
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	var start := enemy.global_position
	var end := target.global_position + Vector2.RIGHT * 32
	var damage_effect := DamageEffect.new()
	var target_array: Array[Node] = [target]
	damage_effect.amount = damage
	
	# 执行缓动动画
	# adamn认为，缓动动画不需要提取为虚函数，或者做成单独的类，封装由于组合
	tween.tween_property(enemy, "global_position", end, 0.4)
	tween.tween_callback(damage_effect.execute.bind(target_array))
	tween.tween_interval(0.25)
	tween.tween_property(enemy, "global_position", start, 0.4)
	
	# 缓动动画完成时，发出完成信号
	tween.finished.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)
