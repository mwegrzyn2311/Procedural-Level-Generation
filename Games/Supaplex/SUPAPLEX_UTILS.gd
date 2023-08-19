extends Node

const POS_NOT_FOUND = Vector2(-1, -1)

# func(Dictionary[Vector2, TILE_ELEMENTS.Ele])
func is_one_open_region(level_dict: Dictionary) -> bool:
	var open_tile_pos: Vector2 = find_first_open_tile_pos(level_dict)
	if open_tile_pos == POS_NOT_FOUND:
		# If only walls, return false
		return false
	var zone: Dictionary = {}
	fill_open_zone_rec(open_tile_pos, level_dict, zone)
	for y in range(CURRENT_LEVEL_INFO.height):
		for x in range(CURRENT_LEVEL_INFO.width):
			var pos: Vector2 = Vector2(x, y)
			if pos not in zone and _is_open_tile(level_dict[pos]):
				return false
	return true

func fill_open_zone_rec(curr_pos: Vector2, level_dict: Dictionary, visited: Dictionary):
	visited[curr_pos] = true
	for unit_vec in CONSTANTS.UNIT_VECTORS:
		var new_pos: Vector2 = curr_pos + unit_vec
		if in_bounds(new_pos) and not new_pos in visited and _is_open_tile(level_dict[new_pos]):
			fill_open_zone_rec(new_pos, level_dict, visited)

func find_first_open_tile_pos(level_dict: Dictionary) -> Vector2:
	for y in range(CURRENT_LEVEL_INFO.height):
		for x in range(CURRENT_LEVEL_INFO.width):
			var pos: Vector2 = Vector2(x, y)
			if _is_open_tile(level_dict[pos]):
				return pos
	return POS_NOT_FOUND

func in_bounds(pos: Vector2) -> bool:
	return pos.x >= 0 and pos.y >= 0 and pos.x < CURRENT_LEVEL_INFO.width and pos.y < CURRENT_LEVEL_INFO.height

func _is_open_tile(ele) -> bool:
	return ele != TILE_ELEMENTS.Ele.WALL and ele != TILE_ELEMENTS.Ele.OBELISK
