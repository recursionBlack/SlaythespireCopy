class_name MapGenerator
extends Node

const X_DIST := 30
const Y_DIST := 25
const PLACEMENT_RANDOMNESS := 5
const FLOORS := 15
const MAP_WIDTH := 7
const PATHS := 6
const MONSTER_ROOM_WEIGHT := 10.0
const SHOP_ROOM_WEIGHT := 2.5
const CAMPFIRE_ROOM_WEIGHT := 4.0


var random_room_type_weights = {
	Room.Type.MONSTER: 0.0,
	Room.Type.CAMPFIRE: 0.0,
	Room.Type.SHOP: 0.0,
}

var random_room_type_total_weight := 0
var map_data: Array[Array]


func _ready() -> void:
	generate_map()


func generate_map() -> Array[Array]:
	map_data = _generate_initial_grid()
	var starting_points := _get_random_starting_points()
	
	for j in starting_points:
		var current_j := j
		for i in FLOORS - 1:
			current_j = _setup_connection(i, current_j)
			
	var i := 0
	for floor in map_data:
		print("floor %s" % i)
		var used_rooms = floor.filter(
			func(room: Room): return room.next_rooms.size() > 0
		)
		print(used_rooms)
		i+=1
	
	return [[]]


func _generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []
	
	for row in FLOORS:
		# 每一层的房间，称为相邻房间
		var adjacent_rooms: Array[Room] = []
		
		for col in MAP_WIDTH:
			var current_room := Room.new()
			var offset := Vector2(randf(), randf()) * PLACEMENT_RANDOMNESS
			current_room.position = Vector2(col * X_DIST, row * -Y_DIST) + offset
			current_room.row = row
			current_room.column = col
			current_room.next_rooms = []
			
			# Boss room has a non-random Y
			if row == FLOORS - 1:
				current_room.position.y = (row + 1) * -Y_DIST
			
			adjacent_rooms.append(current_room)
		
		result.append(adjacent_rooms)
	
	return result


func _get_random_starting_points() -> Array[int]:
	var y_coordinates: Array[int]
	var unique_points: int = 0
	
	while unique_points < 2:
		unique_points = 0
		y_coordinates = []
		
		for i in PATHS:
			var starting_point := randi_range(0, MAP_WIDTH - 1)
			if not y_coordinates.has(starting_point):
				unique_points += 1
			
			y_coordinates.append(starting_point)
	
	return y_coordinates


func _setup_connection(i: int, j: int) -> int:
	var next_room: Room
	var current_room := map_data[i][j] as Room
	
	while not next_room or _would_cross_existing_path(i, j, next_room):
		# 路线的下一个房间，总是在左一，正上，右一，三个房间里选择，还注意不要超出边界范围
		var random_j := clampi(randi_range(j - 1, j + 1), 0, MAP_WIDTH - 1)
		next_room = map_data[i + 1][random_j]
	
	current_room.next_rooms.append(next_room)
	
	return next_room.column


func _would_cross_existing_path(i: int, j: int, room: Room) -> bool:
	var left_neighbour: Room
	var right_neighbour: Room
	
	# if j == 0, there's no left neighbour
	if j > 0:
		left_neighbour = map_data[i][j - 1]
	
	# j == MAP_WIDTH-1, there's no right neighbour
	if j < MAP_WIDTH - 1:
		right_neighbour = map_data[i][j + 1]
	
	# can't cross in right dir if right neighbour goes to left
	# room是我们当前节点想要千万的下一个房间
	if right_neighbour and room.column > j:
		for next_room: Room in right_neighbour.next_rooms:
			if next_room.column < room.column:
				return true
	
	# can't cross in left dir if left neighbour goes to right
	if left_neighbour and room.column < j:
		for next_room: Room in left_neighbour.next_rooms:
			if next_room.column > room.column:
				return true
	
	# 表示可以建立从我们当前房间到目标room的连接，该room可以作为当前节点的next_room
	return false
