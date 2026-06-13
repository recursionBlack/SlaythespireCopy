extends Node
class_name EnemyAction

# 条件性的，和概率性的行动类型
enum Type {CONDITIONAL, CHANCE_BASED}

@export var intent: Intent
# 敌人行动音效
@export var sound: AudioStream
@export var type: Type
@export_range(0.0, 10.0) var chance_weight := 0.0

@onready var accumulated_weight := 0.0

var enemy: Enemy
var target: Node2D


# 虚函数，是否可以执行条件性action，由各个子类自行实现
func is_performable() -> bool:
	return false


func perform_action() -> void:
	pass
