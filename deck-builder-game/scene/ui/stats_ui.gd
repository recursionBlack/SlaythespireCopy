extends HBoxContainer
class_name StatsUI

@onready var block: HBoxContainer = $Block
# %表示正在使用唯一名称这一特性
@onready var block_label: Label = %BlockLabel
@onready var health: HealthUI = $Health


func update_stats(stats: Stats) -> void:
	block_label.text = str(stats.block)
	health.update_stats(stats)
	
	block.visible = stats.block > 0
	health.visible = stats.health > 0
	
