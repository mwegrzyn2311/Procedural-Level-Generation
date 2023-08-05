extends MCTSGameState

class_name MCTSPanelState

var width: int
var height: int

var line: Array[Vector2]
# Keep it in var instead of calculating to optimize
var curr_legal_actions: Array
# When moving the line, we need to pass this arg in order to let know that
#   next generation step will be placing tetromino
var could_place_tetromino: bool
# Array[TetrominoZone]
var tetromino_zones: Array[TetrominoZone]
var lines_gen_finished: bool

func _init(width: int, height: int, line: Array[Vector2], could_place_teromino: bool, tetromino_zones: Array[TetrominoZone], lines_gen_finished: bool):
	self.width = width
	self.height = height
	self.line = line
	self.could_place_tetromino = could_place_teromino
	self.tetromino_zones = []
	self.lines_gen_finished = lines_gen_finished
	self.curr_legal_actions = self.generate_legal_actions()

static func new_initial_state(width: int, height: int) -> MCTSPanelState:
	# Start might we fully random, though I feel like more interesting patterns would emerge from having it on the side
	var start: Vector2 = RNG_UTIL.rand_vec2(1, ((height + 1) / 2)) * 2
	# TODO: Implement
	return MCTSPanelState.new(width, height, [start], false, [], false)

func copy(line: Array[Vector2], new_could_place_tetromino, new_tetromino_zones) -> MCTSPanelState:
	return MCTSPanelState.new(width, height, line, new_could_place_tetromino, new_tetromino_zones, lines_gen_finished)

func move_to(args: Dictionary) -> MCTSPanelState:
	var appended_line: Array[Vector2] = line.duplicate(true)
	var last_pre: Vector2 = line[line.size() - 1]
	appended_line.append(args["dest"])
	var last_post: Vector2 = line[line.size() - 1]
	var new_tetromino_zones: Array[TetrominoZone] = _create_tetromino_zone(line[line.size() - 3], last_pre, last_pre - (last_post - last_pre)) if could_place_tetromino else tetromino_zones
	# If we move from inside the board to the edge, we want to place tetromino next
	var new_could_place_teromino: bool = not _is_on_borders(last_pre) and _is_on_borders(last_post)
	return self.copy(appended_line, new_could_place_teromino, new_tetromino_zones)

func place_tetromino(args: Dictionary) -> MCTSPanelState:
	# TODO: Implement
	var new_tetromino_zones = tetromino_zones.duplicate(true)
	return self.copy(line, false, new_tetromino_zones)

func _in_bounds(pos: Vector2) -> bool:
	return pos.clamp(Vector2(0, 0), Vector2(width, height)) == pos

func _is_on_borders(pos: Vector2) -> bool:
	return pos.x == 0 or pos.x == width - 1 or pos.y == 0 or pos.y == height - 1

func _are_tetrominos_placed():
	return tetromino_zones.filter(func(zone: TetrominoZone): return not zone.is_completed).is_empty()

func _create_tetromino_zone(o: Vector2, a: Vector2, b: Vector2) -> Array[TetrominoZone]:
	var new_tetromino_zones: Array[TetrominoZone] = tetromino_zones.duplicate(true)
	var zone_contour: Array[Vector2] = [a, b]
	var contour_closed: bool = false
	var dir: Vector2 = - Dir2.left_or_right(o, a, b)
	while not contour_closed:
		var try_turn = Dir2.go_right_or_left(a, b, dir)
		# Firstly try to turn correctly, then try going straight, then turn opositely
		for move_vec in [try_turn, b - a, -try_turn]:
			var new_pos: Vector2 = b + move_vec
			if _can_move_to(b, new_pos):
				if new_pos == zone_contour[0]:
					contour_closed = true
					break
				else:
					zone_contour.append(new_pos)
					a = b
					b = new_pos
					break
	var first_zone_element: Vector2 = Vector2(min(o.x, a.x, b.x), min(o.y, a.y, b.y))
	var new_zone_elements: Array[Vector2] = []
	_fill_zone_recursively(zone_contour, new_zone_elements, first_zone_element)
	new_tetromino_zones.append(TetrominoZone.new(new_zone_elements))
	return new_tetromino_zones
	
func _fill_zone_recursively(zone_contour: Array[Vector2], zone_positions: Array[Vector2], pos: Vector2):
	if pos in zone_positions:
		return
	zone_positions.append(pos)
	var unit_vec: Vector2 = Vector2.LEFT
	var new_pos: Vector2 = pos + unit_vec
	if _in_bounds(new_pos) and _exists_line_from_to(pos, pos + Vector2.DOWN):
		_fill_zone_recursively(zone_contour, zone_positions, new_pos)
	unit_vec = Vector2.UP
	new_pos = pos + unit_vec
	if _in_bounds(new_pos) and _exists_line_from_to(pos, pos + Vector2.RIGHT):
		_fill_zone_recursively(zone_contour, zone_positions, new_pos)
	unit_vec = Vector2.RIGHT
	new_pos = pos + unit_vec
	if _in_bounds(new_pos) and _exists_line_from_to(new_pos, new_pos + Vector2.DOWN):
		_fill_zone_recursively(zone_contour, zone_positions, new_pos)
	unit_vec = Vector2.DOWN
	new_pos = pos + unit_vec
	if _in_bounds(new_pos) and _exists_line_from_to(new_pos, new_pos + Vector2.RIGHT):
		_fill_zone_recursively(zone_contour, zone_positions, new_pos)

func _exists_line_from_to(from: Vector2, to: Vector2):
	var to_idx: int = line.find(to)
	# Check we try to move along the line
	if not to_idx:
		return false
	else:
		# from and to have to be neighbours on the line
		return (to_idx > 0 and line[to_idx - 1] == from) or (to_idx < line.size() - 1 and line[to_idx + 1] == from)

func _can_move_to(from: Vector2, to: Vector2) -> bool:
	# Either we move along the borders or there exists a line from-to
	return (_is_on_borders(from) and _is_on_borders(to)) or _exists_line_from_to(from, to)

func _finish_line_gen():
	self.lines_gen_finished = true
	if line.size() >= 2:
		var o: Vector2 = line[line.size() - 2]
		var a: Vector2 = line[line.size() - 1]
		if _is_on_borders(a) and not _is_on_borders(o):
			var b: Vector2 = a + Vector2((a - o).y, (a - o).x) * RNG_UTIL.rand_pos_neg()
			_create_tetromino_zone(o, a ,b)

# =======================
# Abstract functions overrides here

# TODO: Add placing tetromino here
func generate_legal_actions() -> Array:
	return generate_move_actions() + generate_tetromino_actions()

func generate_tetromino_actions() -> Array:
	var actions = []
	if _are_tetrominos_placed():
		return actions
	else:
		# TODO: Maybe we should limit number of those?
		# To not make the tree too wide, we limit the number of possible tetromino actions but we want variety, so we randomize it
		TETROMINO_UTIL.types_arr.shuffle()
		# This loop comes in first so that we can fill one zone completely before starting the other one
		for zone in tetromino_zones.filter(func(zone: TetrominoZone): return not zone.is_completed):
			for type in TETROMINO_UTIL.types_arr:
				var tetromino_opt: Tetromino = zone.can_place_tetromino(type)
				if tetromino_opt != null:
					actions.append(MCTSAction.new(Callable(self, "place_tetromino"), {"tetromino": tetromino_opt}))
					if actions.size == CURRENT_PANEL.max_tetromino_actions:
						return actions
		return actions

# TODO: Might create something to put and end earlier
func generate_move_actions() -> Array:
	if lines_gen_finished:
		return []
	var curr_pos: Vector2 = line[line.size() - 1]
	var dest_positions: Array = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]\
		.map(func(unit_vec: Vector2): return curr_pos + unit_vec * 2)\
		.filter(func(next: Vector2): return !line.has(next) && _in_bounds(next))
	if dest_positions.is_empty():
		_finish_line_gen()
	# Create zone but make sure it doesnt invoke again (a flag or smth
	return dest_positions.map(func(dest: Vector2): return MCTSAction.new(Callable(self, "move_to"), {"dest": dest}))


func legal_actions() -> Array:
	return curr_legal_actions

# TODO: It would be best to somehow return number of solutions
func generation_result() -> float:
	return line.size()

# We might return true if either no more legal moves exist or a satisfactory result is found
func is_generation_completed() -> bool:
	return curr_legal_actions.size() == 0
	
func get_level_dict() -> Dictionary:
	var res: Dictionary = {}
	for y in range(height):
		for x in range(width):
			res[Vector2(x, y)] = PANEL_ELEMENTS.Ele.EMPTY
	res[line[0]] = PANEL_ELEMENTS.Ele.START
	for i in range(1, line.size()):
		res[line[i]] = PANEL_ELEMENTS.Ele.INTERSECTION
		res[(line[i] + line[i - 1]) / 2] = PANEL_ELEMENTS.Ele.PIPE
	res[line[line.size() - 1]] = PANEL_ELEMENTS.Ele.FINISH
	
	return res
