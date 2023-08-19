extends Node


# func(Vector2, Vector2, Dictionary[Vector2, TetrominoType], int, int)
static func number_of_solutions_legacy(start: Vector2, finish: Vector2, tetrominos: Dictionary, width: int, height: int) -> int:
	var sols = no_of_sols_recursive_legacy([start], start, finish, tetrominos, width, height)
	return sols

static func no_of_sols_recursive_legacy(line: Array[Vector2], curr_pos: Vector2, finish: Vector2, tetrominos: Dictionary, width: int, height: int) -> int:
	if curr_pos == finish:
		if is_correct_solution(line, tetrominos, width, height):
			return 1
		else:
			return 0
	var next_positions: Array = CONSTANTS.UNIT_VECTORS\
		.map(func(unit_vec: Vector2) -> Vector2: return curr_pos + unit_vec * 2)\
		.filter(func(next: Vector2) -> bool: return in_bounds(next, width, height) and !line.has(next))
	
	var res: int = 0
	for next_pos in next_positions:
		line.append(next_pos)
		res += no_of_sols_recursive_legacy(line, next_pos, finish, tetrominos, width, height)
		line.erase(next_pos)
	return res

# func(Vector2, Vector2, Dictionary[Vector2, TetrominoType], int, int)
static func number_of_solutions(start: Vector2, finish: Vector2, tetrominos: Dictionary, width: int, height: int) -> int:
	var sols = no_of_sols_recursive([start], [], [], start, finish, tetrominos, width, height)
	return sols

static func no_of_sols_recursive(line: Array[Vector2], unique_zone_sets, valid_zones, curr_pos: Vector2, finish: Vector2, tetrominos: Dictionary, width: int, height: int) -> int:
	if curr_pos == finish:
		if is_correct_unique_solution(line, unique_zone_sets, valid_zones, tetrominos, width, height):
			return 1
		else:
			return 0
	var next_positions: Array = CONSTANTS.UNIT_VECTORS\
		.map(func(unit_vec: Vector2) -> Vector2: return curr_pos + unit_vec * 2)\
		.filter(func(next: Vector2) -> bool: return in_bounds(next, width, height) and !line.has(next))
	
	var res: int = 0
	for next_pos in next_positions:
		line.append(next_pos)
		res += no_of_sols_recursive(line, unique_zone_sets, valid_zones, next_pos, finish, tetrominos, width, height)
		line.erase(next_pos)
	return res

static func is_correct_unique_solution(sim_line: Array[Vector2], unique_zone_sets, valid_zones, tetrominos: Dictionary, width: int, height: int) -> bool:
	if tetrominos.is_empty():
		return true
	var a: Vector2
	var b: Vector2 = sim_line[0]
	var curr_zones: Array = []
	for i in range(1, sim_line.size()):
		a = b
		b = sim_line[i]
		if i < sim_line.size() - 1:
			if not on_borders(a, width, height) and on_borders(b, width, height):
				var c: Vector2 = b + (b - sim_line[i + 1])
				if not is_correct_tetromino_zone(a, b, c, sim_line, tetrominos, width, height, unique_zone_sets, valid_zones, curr_zones):
					return false
		else:
			var last_dir: Vector2 = (b - a)
			var norm: Vector2 = Vector2(last_dir.y, last_dir.x)
			var c1: Vector2 = b + norm
			var c2: Vector2 = b - norm
			if (in_bounds(c1, width, height) and not is_correct_tetromino_zone(a, b, c1, sim_line, tetrominos, width, height, unique_zone_sets, valid_zones, curr_zones)) or (in_bounds(c2, width, height) and not is_correct_tetromino_zone(a, b, c2, sim_line, tetrominos, width, height, unique_zone_sets, valid_zones, curr_zones)):
				return false
				
	if COLLECTION_UTIL.deep_has(unique_zone_sets, curr_zones):
		return false
	else:
		unique_zone_sets.append(curr_zones)
		return true

#static func _zone_in_unique_zones(unique_zones, zone_positions) -> bool:
#	for unique_zone in unique_zones:
#		for

static func is_correct_solution(sim_line: Array[Vector2], tetrominos: Dictionary, width: int, height: int) -> bool:
	var a: Vector2
	var b: Vector2 = sim_line[0]
	for i in range(1, sim_line.size()):
		a = b
		b = sim_line[i]
		if i < sim_line.size() - 1:
			if not on_borders(a, width, height) and on_borders(b, width, height):
				var c: Vector2 = b + (b - sim_line[i + 1])
				if not is_correct_tetromino_zone(a, b, c, sim_line, tetrominos, width, height):
					return false
		else:
			var last_dir: Vector2 = (b - a)
			var norm: Vector2 = Vector2(last_dir.y, last_dir.x)
			var c1: Vector2 = b + norm
			var c2: Vector2 = b - norm
			if (in_bounds(c1, width, height) and not is_correct_tetromino_zone(a, b, c1, sim_line, tetrominos, width, height)) or (in_bounds(c2, width, height) and not is_correct_tetromino_zone(a, b, c2, sim_line, tetrominos, width, height)):
				return false
	return true
		
static func is_correct_tetromino_zone(a: Vector2, b: Vector2, c: Vector2, sim_line: Array[Vector2], tetrominos: Dictionary, width: int, height: int, unique_zones = null, valid_zones = null, curr_zone_set = null) -> bool:
	var zone_corner: Vector2 = Vector2(min(a.x, b.x, c.x), min(a.y, b.y, c.y)) + Vector2.ONE
	var zone_positions: Array[Vector2] = []
	fill_zone_recursively(zone_positions, zone_corner, sim_line, width, height)
	# Dictionary[Vector2, bool]
	var zone_dict: Dictionary = {}
	for pos in zone_positions:
		zone_dict[pos] = false
	var tetromino_types_in_zone: Array = tetrominos.keys()\
		.filter(func(tetromino_pos): return tetromino_pos in zone_positions)\
		.map(func(tetromino_pos): return tetrominos[tetromino_pos])
	
	if tetromino_types_in_zone.is_empty():
		return true
		
	if valid_zones != null and COLLECTION_UTIL.deep_has(valid_zones, zone_positions):
		curr_zone_set.append(zone_positions)
		return true
	
	# This is only for the sake of optimiation - to return early if it would fail anyways
	if tetromino_types_in_zone\
		.map(func(tetr_type) -> int: return TETROMINO_UTIL.TypeToShape[tetr_type].size())\
		.reduce(func(a, b): return a + b, 0) != zone_positions.size():
		return false
	
	if _try_placing(zone_dict, tetromino_types_in_zone):
		if curr_zone_set != null:
			valid_zones.append(zone_positions)
			curr_zone_set.append(zone_positions)
		return true
	else:
		return false

static func _try_placing(zone_dict: Dictionary, types_remaining: Array) -> bool:
	if types_remaining.is_empty() and zone_dict.values().filter(func(occupied): return not occupied).is_empty():
		return true
	var type = types_remaining.pop_back()
	for shape in TETROMINO_UTIL.rotated_shapes[type]:
		for pos in zone_dict:
			if not zone_dict[pos]:
				var offset: Vector2 = pos - shape[0] * 2
				var positions: Array = []
				var fits: bool = true
				for shape_pos in shape.map(func(shape_pos): return shape_pos * 2):
					var curr_pos: Vector2 = shape_pos + offset
					if curr_pos not in zone_dict or zone_dict[curr_pos]:
						fits = false
						break
					positions.append(curr_pos)
				if fits:
					for curr_pos in positions:
						zone_dict[curr_pos] = true
					if _try_placing(zone_dict, types_remaining):
						return true
					for curr_pos in positions:
						zone_dict[curr_pos] = false
	types_remaining.append(type)
	return false

static func fill_zone_recursively(zone_positions: Array[Vector2], pos: Vector2, full_line: Array[Vector2], width: int, height: int):
	zone_positions.append(pos)
	for unit_vec in CONSTANTS.UNIT_VECTORS:
		var new_pos: Vector2 = pos + unit_vec * 2
		var normal: Vector2 = Vector2(unit_vec.y, unit_vec.x)
		var potential_line_from: Vector2 = pos + unit_vec + normal
		var potential_line_to: Vector2 = pos + unit_vec - normal
		if new_pos not in zone_positions and in_bounds(new_pos, width, height) and not exists_line_from_to(full_line, potential_line_from, potential_line_to):
			fill_zone_recursively(zone_positions, new_pos, full_line, width, height)

static func in_bounds(pos: Vector2, width: int, height: int) -> bool:
	return pos.x >= 0 and pos.y >= 0 and pos.x < width and pos.y < height


static func on_borders(pos: Vector2, width: int, height: int) -> bool:
	return pos.x == 0 or pos.x == width - 1 or pos.y == 0 or pos.y == height - 1
	
static func exists_line_from_to(full_line: Array[Vector2], from: Vector2, to: Vector2):
	var to_idx: int = full_line.find(to)
	# Check we try to move along the line
	if to_idx == -1:
		return false
	else:
		# from and to have to be neighbours on the line
		return (to_idx > 0 and full_line[to_idx - 1] == from) or (to_idx < full_line.size() - 1 and full_line[to_idx + 1] == from)
