extends MCTSGameState

class_name MCTSPanelState

const A: float = 3.0
const B: float = 1.0
const C: float = 1.0

var width: int
var height: int

var line: Array[Vector2]
# Keep it in var instead of calculating to optimize
var curr_legal_actions: Array
# When moving the line, we need to pass this arg in order to let know that
#   next generation step will be placing tetromino
var could_place_tetromino: bool
# Array[TetrominoZone]
var tetromino_zones
var lines_gen_finished: bool
var is_terminal: bool
var X: float
var gen_res: float

func _init(width: int, height: int, line: Array[Vector2], could_place_teromino: bool, tetromino_zones, lines_gen_finished: bool):
	self.width = width
	self.height = height
	self.line = line
	self.could_place_tetromino = could_place_teromino
	self.tetromino_zones = tetromino_zones
	self.lines_gen_finished = lines_gen_finished
	self.curr_legal_actions = self.generate_legal_actions()
	self.curr_legal_actions.shuffle()
	self.is_terminal = (self.curr_legal_actions.size() == 0)
	self.X = -1.0
	self.gen_res = -1.0

static func new_initial_state(width: int, height: int) -> MCTSPanelState:
	# Starts on the side for the sake of current implementation of tetromino generation
	var start: Vector2 = RNG_UTIL.rand_vec2(1, ((height + 1) / 2)) * 2
	# TODO: Implement
	return MCTSPanelState.new(width, height, [start], false, [], false)

func copy(line: Array[Vector2], new_could_place_tetromino, new_tetromino_zones) -> MCTSPanelState:
	return MCTSPanelState.new(width, height, line, new_could_place_tetromino, new_tetromino_zones, lines_gen_finished)

func move_to(args: Dictionary) -> MCTSPanelState:
	var appended_line: Array[Vector2] = line.duplicate(true)
	var last_pre: Vector2 = appended_line[appended_line.size() - 1]
	appended_line.append(args["dest"])
	var last_post: Vector2 = appended_line[appended_line.size() - 1]
	var new_tetromino_zones = _create_tetromino_zone(appended_line[appended_line.size() - 3], last_pre, last_pre - (last_post - last_pre), appended_line) if could_place_tetromino else tetromino_zones
	# If we move from inside the board to the edge, we want to place tetromino next
	var new_could_place_teromino: bool = not _is_on_borders(last_pre) and _is_on_borders(last_post)
	return self.copy(appended_line, new_could_place_teromino, new_tetromino_zones)

func place_tetromino(args: Dictionary) -> MCTSPanelState:
	var tetromino = args["tetromino"]
	var zone_idx = args["zone_idx"]
	var new_tetromino_zones = _new_zones()
	new_tetromino_zones[zone_idx].place_tetromino(tetromino)
	return self.copy(line, false, new_tetromino_zones)

func _new_zones():
	return self.tetromino_zones.map(func(zone: TetrominoZone) -> TetrominoZone: return zone.copy())

func _in_bounds(pos: Vector2) -> bool:
	return pos.clamp(Vector2(0, 0), Vector2(width - 1, height - 1)) == pos

func _is_on_borders(pos: Vector2) -> bool:
	return pos.x == 0 or pos.x == width - 1 or pos.y == 0 or pos.y == height - 1

func _are_tetrominos_placed():
	return tetromino_zones.filter(func(zone: TetrominoZone): return not zone.is_completed).is_empty()

func _create_tetromino_zone(o: Vector2, a: Vector2, b: Vector2, curr_line: Array[Vector2]):
	var new_tetromino_zones = _new_zones()
	# Inside the square created by the first three positions(two vectors) of the zone
	var first_zone_element: Vector2 = Vector2(min(o.x, a.x, b.x), min(o.y, a.y, b.y)) + Vector2.ONE
	var new_zone_elements: Array[Vector2] = []
	_fill_zone_recursively(new_zone_elements, first_zone_element, curr_line)
	new_tetromino_zones.append(TetrominoZone.initial_state(new_zone_elements))
	return new_tetromino_zones

func _fill_zone_recursively(zone_positions: Array[Vector2], pos: Vector2, full_line: Array[Vector2]):
	zone_positions.append(pos)
	for unit_vec in CONSTANTS.UNIT_VECTORS:
		var new_pos: Vector2 = pos + unit_vec * 2
		var normal: Vector2 = Vector2(unit_vec.y, unit_vec.x)
		var potential_line_from: Vector2 = pos + unit_vec + normal
		var potential_line_to: Vector2 = pos + unit_vec - normal
		if new_pos not in zone_positions and _in_bounds(new_pos) and not _exists_line_from_to(full_line, potential_line_from, potential_line_to):
			_fill_zone_recursively(zone_positions, new_pos, full_line)

func _exists_line_from_to(full_line: Array[Vector2], from: Vector2, to: Vector2):
	var to_idx: int = full_line.find(to)
	# Check we try to move along the line
	if to_idx == -1:
		return false
	else:
		# from and to have to be neighbours on the line
		return (to_idx > 0 and full_line[to_idx - 1] == from) or (to_idx < full_line.size() - 1 and full_line[to_idx + 1] == from)

func _can_move_to(full_line: Array[Vector2], from: Vector2, to: Vector2) -> bool:
	# Either we move along the borders or there exists a line from-to
	return (_is_on_borders(from) and _is_on_borders(to)) or _exists_line_from_to(full_line, from, to)

func _finish_line_gen():
	self.lines_gen_finished = true
	if line.size() >= 2:
		var o: Vector2 = line[line.size() - 2]
		var a: Vector2 = line[line.size() - 1]
		if _is_on_borders(a) and not _is_on_borders(o):
			var b: Vector2 = a + Vector2((a - o).y, (a - o).x) * RNG_UTIL.rand_pos_neg()
			_create_tetromino_zone(o, a ,b, line)

func _is_start(pos: Vector2):
	return line[0] == pos 

# =======================
# Abstract functions overrides here

# TODO: Add placing tetromino here
func generate_legal_actions() -> Array:
	# This ifelse is there to reduce the width of the tree
	# Append is there cause it might generate a zone but only if it would return empty list
	if _are_tetrominos_placed():
		return generate_move_actions() + generate_tetromino_actions()
	else:
		return generate_tetromino_actions()

func generate_tetromino_actions() -> Array:
	var actions = []
	if _are_tetrominos_placed():
		return actions
	else:
		# TODO: Experiment with different max_tetromino_actions values
		# To not make the tree too wide, we limit the number of possible tetromino actions but we want variety, so we randomize it
		TETROMINO_UTIL.types_arr.shuffle()
		# This loop comes in first so that we can fill one zone completely before starting the other one
		for i in range(tetromino_zones.size()):
			var zone = tetromino_zones[i]
			if zone.is_completed:
				continue
			for type in TETROMINO_UTIL.types_arr:
					_try_create_tetromino_action(actions, zone, i, type)
					if actions.size() == CURRENT_PANEL.max_tetromino_actions:
						return actions
			if not CURRENT_PANEL.is_one_by_one_tetromino_disabled:
				var type: TETROMINO_UTIL.Type = TETROMINO_UTIL.Type.ONE_BY_ONE
				_try_create_tetromino_action(actions, zone, i, type)
		return actions

func _try_create_tetromino_action(actions: Array, zone: TetrominoZone, zone_idx: int, type: TETROMINO_UTIL.Type):
	var tetromino_opt: Tetromino = zone.can_place_tetromino(type)
	if tetromino_opt != null:
		actions.append(MCTSAction.new(Callable(self, "place_tetromino"), {"tetromino": tetromino_opt, "zone_idx": zone_idx}))

# TODO: Might create something to put an end earlier
func generate_move_actions() -> Array:
	if lines_gen_finished:
		return []
	var curr_pos: Vector2 = line[line.size() - 1]
	var dest_positions: Array = CONSTANTS.UNIT_VECTORS\
		.map(func(unit_vec: Vector2): return curr_pos + unit_vec * 2)\
		.filter(func(next: Vector2) -> bool: return _in_bounds(next) and !line.has(next))
	if dest_positions.is_empty():
		_finish_line_gen()
	# Create zone but make sure it doesnt invoke again (a flag or smth
	return dest_positions.map(func(dest: Vector2): return MCTSAction.new(Callable(self, "move_to"), {"dest": dest}))

func legal_actions() -> Array:
	return curr_legal_actions

# TODO: It would be best to somehow return number of solutions
# TODO: Consider giving tetromino elements values to further parameterize gen result
func generation_result() -> float:
	if self.gen_res != -1.0:
		return self.gen_res
	
	self.X = 2.0
	# Dictionary[Vector2, TETROMINO_UTILS.Type]
	var tetromino_dict: Dictionary = {}
	for zone in tetromino_zones:
		if not zone.is_completed:
			self.X = 0.0
		for tetromino in zone.tetrominos:
			tetromino_dict[tetromino.pos] = tetromino.type

	self.X = float(PANEL_UTILS.number_of_solutions(line[0], line[line.size() - 1], tetromino_dict, width, height))
	if self.X == 0.0:
		self.gen_res = -INF * self.max_score()
		return self.gen_res
	var Y: float = float(tetromino_zones.size())
	var w: float = float(width / 2)
	var h: float = float(width / 2)
	var sqrt_wh: float = sqrt(w * h)
	var Z: float = float(tetromino_zones.map(func(zone): return zone.zone_tiles.size()).reduce(COLLECTION_UTIL.num_sum, 0)) / (w * h)

	self.gen_res = A * max(0.0, -(X - sqrt_wh - 1) * (X + sqrt_wh - 1)) / (w * h) +  B * Y / (Y + 1) + C * 4 * Z * (1 - Z)
	return self.gen_res

func max_score() -> float:
	return A + B + C

# We might return true if either no more legal moves exist or a satisfactory result is found
func is_generation_completed() -> bool:
	return self.is_terminal
	
func get_level_dict() -> Dictionary:
	print("Generated lvl with " + str(X) + " solutions and quality of " + str(gen_res / max_score()))
	var res: Dictionary = {}
	for y in range(height):
		for x in range(width):
			# TODO: Optimize
			if x % 2 == 0 and y % 2 == 0:
				res[Vector2(x, y)] = PANEL_ELEMENTS.Ele.INTERSECTION
			elif x % 2 == 0 or y % 2 == 0:
				res[Vector2(x, y)] = PANEL_ELEMENTS.Ele.PIPE
			else:
				res[Vector2(x, y)] = PANEL_ELEMENTS.Ele.EMPTY
	
	res[line[0]] = PANEL_ELEMENTS.Ele.START
	res[line[line.size() - 1]] = PANEL_ELEMENTS.Ele.FINISH
	
	for tetromino_zone in tetromino_zones:
		for tetromino in tetromino_zone.tetrominos:
			res[tetromino.pos] = tetromino
	
	return res
	
func get_debug_level_dict() -> Dictionary:
	var res: Dictionary = {}
	for y in range(height):
		for x in range(width):
			res[Vector2(x, y)] = PANEL_ELEMENTS.Ele.EMPTY
	res[line[0]] = PANEL_ELEMENTS.Ele.START
	
	for i in range(1, line.size()):
		res[line[i]] = PANEL_ELEMENTS.Ele.INTERSECTION
		res[(line[i] + line[i - 1]) / 2] = PANEL_ELEMENTS.Ele.PIPE
	res[line[line.size() - 1]] = PANEL_ELEMENTS.Ele.FINISH
	
	for tetromino_zone in tetromino_zones:
		for tetromino in tetromino_zone.tetrominos:
			res[tetromino.pos] = tetromino
	
	return res
