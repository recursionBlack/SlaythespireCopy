class_name Room
extends Resource

# 房间的基本信息类
enum	 Type {NOT_ASSIGNED, MONSTER, TREASURE, CAMPFIRE, SHOP, BOSS}

@export var type: Type
@export var row: int
@export var column: int
@export var position: Vector2
@export var next_rooms: Array[Room]
@export var selected := false


func _to_string() -> String:
	# 打印出房间类型的首字母
	return "%s (%s)" % [column, Type.keys()[type][0]]
