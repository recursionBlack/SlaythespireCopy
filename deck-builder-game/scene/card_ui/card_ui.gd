extends Control
class_name CardUI

# 拖拽卡片时，重新指定其父节点
signal reparent_requested(which_card_ui: CardUI)

@onready var color: ColorRect = $Color
@onready var state: Label = $State
