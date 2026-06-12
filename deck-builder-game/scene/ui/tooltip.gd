extends PanelContainer
class_name Tooltip

# 淡出动画所需时间
@export var fade_secounds := 0.2

@onready var tooltip_icon: TextureRect = %TooltipIcon
@onready var tooltip_text_label: RichTextLabel = %TooltipText

var tween: Tween
var is_visible := false


func _ready() -> void:
	Events.card_tooltip_requested.connect(show_tooltip)
	Events.tooltip_hide_requested.connect(hide_tooltip)
	modulate = Color.TRANSPARENT
	hide()


func show_tooltip(icon: Texture, text: String) -> void:
	is_visible = true
	if tween:
		tween.kill()
	
	tooltip_icon.texture = icon
	tooltip_text_label.text = text
	# 设置缓动和过渡模式，并调用show，使self不再隐藏
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(show)
	tween.tween_property(self, "modulate", Color.WHITE, fade_secounds)


func hide_tooltip() -> void:
	is_visible = false
	if tween:
		tween.kill()
	
	# 通过增加一个定时器，来避免在多张卡牌之间快速滑动时，仍会调用隐藏函数的闪烁感
	get_tree().create_timer(fade_secounds, false).timeout.connect(hide_animation)


func hide_animation() -> void:
	if not is_visible:
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_secounds)
		tween.tween_callback(hide)
