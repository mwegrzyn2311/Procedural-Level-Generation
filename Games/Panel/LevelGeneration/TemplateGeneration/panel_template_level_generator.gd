extends TemplateLevelGenerator

class_name PanelTemplateLevelGenerator

var START_TEMPLATES: LevelTemplates = PANEL_TEMPLATES.START_TEMPLATES_1

func _init(width: int, height: int, level_templates: LevelTemplates):
	super(width, height, level_templates)

func generate_level() -> Dictionary:
	var res: Dictionary
	var good_panel_found: bool = false
	var tetromino_zones: Array[TetrominoZone]
	while not good_panel_found:
		print("Trying again")
		res = {}
		var start_at: Vector2 = Vector2(0, RNG_UTIL.RNG.randi_range(0, height/t_height - 1))
		var offset: Vector2 = Vector2(0, start_at.y * t_height)
		var start_template: Dictionary = RNG_UTIL.choice(START_TEMPLATES.templates).duplicate(true)
		for pos in start_template:
			res[pos + offset] = start_template[pos]
		res = super._generate_level(res, [start_at], false)
		tetromino_zones = []
		good_panel_found = _try_to_connect_line(res, offset, tetromino_zones) and _try_to_place_tetrominos(tetromino_zones)
	return _make_ready_for_usage(res, tetromino_zones)

# TODO: This is bugged in finish is not on borders!!!
func _try_to_place_tetrominos(tetromino_zones: Array[TetrominoZone]) -> bool:
	tetromino_zones = tetromino_zones\
		.filter(func(tetromino_zone: TetrominoZone) -> bool: return tetromino_zone.zone_tiles.size() > 1)
	tetromino_zones.shuffle()
	for i in range(tetromino_zones.size() - 1):
		if not _try_to_fill_in_zone_rec(tetromino_zones[i]):
			return false
	return true

func _try_to_fill_in_zone_rec(tetromino_zone: TetrominoZone) -> bool:
	if tetromino_zone.is_completed:
		return true
	var tmp_tetromino_types: Array[TETROMINO_UTIL.Type] = TETROMINO_UTIL.types_arr.duplicate(true)
	tmp_tetromino_types.shuffle()
	for type in tmp_tetromino_types:
		var tetromino_opt: Tetromino = tetromino_zone.can_place_tetromino(type)
		if tetromino_opt != null:
			tetromino_zone.place_tetromino(tetromino_opt)
			if _try_to_fill_in_zone_rec(tetromino_zone):
				return true
			tetromino_zone.erase_tetromino(tetromino_opt)
	return false

func _try_to_connect_line(res: Dictionary, start: Vector2, tetromino_zones: Array[TetrominoZone]) -> bool:
	var visited: Array[Vector2] = []
	var curr_pos: Vector2 = start
	var last_pipe: Vector2 = Vector2(-1, -1)
	var finished: bool = false
	var could_place_tetromino: bool = false
	while not finished:
		if last_pipe != Vector2(-1, -1):
			visited.append(last_pipe)
		visited.append(curr_pos)
		if could_place_tetromino:
			var b : Vector2 = visited[-3]
			var a: Vector2 = b + (b - curr_pos)
			tetromino_zones.append(_create_tetromino_zone(a, b, visited[-5], res))
			could_place_tetromino = false
		if last_pipe != Vector2(-1, -1) and not _is_on_borders(last_pipe) and _is_on_borders(curr_pos):
			could_place_tetromino = true
		var next_pipe = CONSTANTS.UNIT_VECTORS\
			.map(func(unit_vec: Vector2) -> Vector2: return curr_pos + unit_vec)\
			.filter(func(dest: Vector2) -> bool: return dest in res and dest != last_pipe and res[dest] == PANEL_ELEMENTS.Ele.LINE)
		if next_pipe.size() > 2:
			return false
		elif next_pipe.size() == 0:
			if curr_pos.x == width - 1:
				var intersection_above: Vector2 = curr_pos + Vector2.UP * 2
				var intersection_below: Vector2 = curr_pos + Vector2.DOWN * 2
				var can_connect_up: bool = intersection_above in res and res[intersection_above] == PANEL_ELEMENTS.Ele.LINE and not intersection_above in visited
				var can_connect_down: bool = intersection_below in res and res[intersection_below] == PANEL_ELEMENTS.Ele.LINE and not intersection_below in visited
				if can_connect_up and can_connect_down:
					return false
				elif can_connect_up:
					var pipe_pos: Vector2 = curr_pos + Vector2.UP
					res[pipe_pos] = PANEL_ELEMENTS.Ele.LINE
					curr_pos = intersection_above
					last_pipe = pipe_pos
				elif can_connect_down:
					var pipe_pos: Vector2 = curr_pos + Vector2.DOWN
					res[pipe_pos] = PANEL_ELEMENTS.Ele.LINE
					curr_pos = intersection_below
					last_pipe = pipe_pos
				else:
					res[curr_pos] = PANEL_ELEMENTS.Ele.FINISH
					finished = true
			elif curr_pos.y == height -1:
				var intersection_right: Vector2 = curr_pos + Vector2.RIGHT * 2
				var intersection_left: Vector2 = curr_pos + Vector2.LEFT * 2
				var can_connect_right: bool = intersection_right in res and res[intersection_right] == PANEL_ELEMENTS.Ele.LINE and not intersection_right in visited
				var can_connect_left: bool = intersection_left in res and res[intersection_left] == PANEL_ELEMENTS.Ele.LINE and not intersection_left in visited
				if can_connect_right and can_connect_left:
					return false
				elif can_connect_right:
					var pipe_pos: Vector2 = curr_pos + Vector2.RIGHT
					res[pipe_pos] = PANEL_ELEMENTS.Ele.LINE
					curr_pos = intersection_right
					last_pipe = pipe_pos
				elif can_connect_left:
					var pipe_pos: Vector2 = curr_pos + Vector2.LEFT
					res[pipe_pos] = PANEL_ELEMENTS.Ele.LINE
					curr_pos = intersection_left
					last_pipe = pipe_pos
				else:
					res[curr_pos] = PANEL_ELEMENTS.Ele.FINISH
					finished = true
			else:
				res[curr_pos] = PANEL_ELEMENTS.Ele.FINISH
				finished = true
		else:
			curr_pos = curr_pos + (next_pipe[0] - curr_pos) * 2
			last_pipe = next_pipe[0]
	if _is_on_borders(curr_pos):
		var c: Vector2 = visited[-3]
		var b: Vector2 = curr_pos
		var last_dir: Vector2 = curr_pos - last_pipe
		var dir: Vector2 = Vector2(last_dir.y, last_dir.x)
		var a1: Vector2 = b + dir * 2
		var a2: Vector2 = b - dir * 2
		if _is_in_map(a1):
			tetromino_zones.append(_create_tetromino_zone(a1, b, c, res))
		if _is_in_map(a2):
			tetromino_zones.append(_create_tetromino_zone(a2, b, c, res))
	else:
		# TODO: Remove this. This is temporary return false because tetromino placement doesn't work for inside line
		return false
		var c: Vector2 = visited[-3]
		var b: Vector2 = curr_pos
		var last_dir: Vector2 = curr_pos - last_pipe
		var dir: Vector2 = Vector2(last_dir.y, last_dir.x)
		var a1: Vector2 = b + dir * 2
		var a2: Vector2 = b - dir * 2
		if _is_in_map(a1):
			tetromino_zones.append(_create_tetromino_zone(a1, b, c, res))
		elif _is_in_map(a2):
			tetromino_zones.append(_create_tetromino_zone(a2, b, c, res))
	for y in range(height):
		for x in (range(1, width, 2) if y % 2 == 0 else range(0, width, 2)):
			var pos: Vector2 = Vector2(x, y)
			if pos in res and res[pos] == PANEL_ELEMENTS.Ele.LINE and not pos in visited:
				return false
	for y in range(height):
		var pos: Vector2 = Vector2(width - 1, y)
		if not pos in res:
			res[pos] = PANEL_ELEMENTS.Ele.INTERSECTION if y % 2 == 0 else PANEL_ELEMENTS.Ele.PIPE
	for x in range(width):
		var pos: Vector2 = Vector2(x, height - 1)
		if not pos in res:
			res[pos] = PANEL_ELEMENTS.Ele.INTERSECTION if x % 2 == 0 else PANEL_ELEMENTS.Ele.PIPE
	if tetromino_zones.size() <= 1:
		return false
	if tetromino_zones\
		.filter(func(tetromino_zone: TetrominoZone) -> bool: return tetromino_zone.zone_tiles.size() > 1)\
		.size() < 2:
		return false
	return true

func _is_on_borders(pos: Vector2) -> bool:
	return pos.x == 0 or pos.x == width - 1 or pos.y == 0 or pos.y == height - 1

func _create_tetromino_zone(a: Vector2, b: Vector2, c: Vector2, res: Dictionary) -> TetrominoZone:
	# Inside the square created by the first three positions(two vectors) of the zone
	var first_zone_element: Vector2 = Vector2(min(a.x, b.x, c.x), min(a.y, b.y, c.y)) + Vector2.ONE
	var new_zone_elements: Array[Vector2] = []
	_fill_zone_recursively(new_zone_elements, first_zone_element, res)
	return TetrominoZone.initial_state(new_zone_elements)

func _fill_zone_recursively(zone_positions: Array[Vector2], pos: Vector2, res: Dictionary):
	zone_positions.append(pos)
	for unit_vec in CONSTANTS.UNIT_VECTORS:
		var new_pos: Vector2 = pos + unit_vec * 2
		var normal: Vector2 = Vector2(unit_vec.y, unit_vec.x)
		var line_at: Vector2 = pos + unit_vec
		if not new_pos in zone_positions and _is_in_map(new_pos) and not _exists_line_at(res, line_at):
			_fill_zone_recursively(zone_positions, new_pos, res)

func _exists_line_at(res: Dictionary, pos: Vector2) -> bool:
	return pos in res and res[pos] == PANEL_ELEMENTS.Ele.LINE

func _is_in_map(pos: Vector2):
	return pos.x > 0 and pos.y > 0 and pos.x < width and pos.y < height

func _is_intersection(pos: Vector2) -> bool:
	return int(pos.x) % 2 == 0 and int(pos.y) % 2 == 0

func _make_ready_for_usage(res: Dictionary, tetromino_zones: Array[TetrominoZone]) -> Dictionary:
	COLLECTION_UTIL.nice_print_dict(res)
	_hide_lines(res)
	_mark_tetrominos(res, tetromino_zones)
	return res

func _hide_lines(res: Dictionary):
	for pos in res:
		if res[pos] == PANEL_ELEMENTS.Ele.LINE:
			res[pos] = PANEL_ELEMENTS.Ele.INTERSECTION if _is_intersection(pos) else PANEL_ELEMENTS.Ele.PIPE

func _mark_tetrominos(res: Dictionary, tetromino_zones: Array[TetrominoZone]):
	for zone in tetromino_zones:
		for tetromino in zone.tetrominos:
			res[tetromino.pos] = tetromino
