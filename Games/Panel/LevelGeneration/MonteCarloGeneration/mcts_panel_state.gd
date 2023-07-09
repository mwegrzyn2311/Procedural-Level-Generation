extends MCTSGameState

class_name MCTSPanelState

var width: int
var height: int

var line: Array[Vector2]
# Keep it in var instead of calculating to optimize
var curr_legal_actions: Array;
# When moving the line, we need to pass this arg in order to let know that
#   next generation step will be placing tetromino
var could_place_tetromino: bool

func _init(width: int, height: int, line: Array[Vector2], could_place_teromino: bool):
	self.width = width
	self.height = height
	self.line = line
	self.could_place_tetromino = could_place_teromino
	self.curr_legal_actions = self.generate_legal_actions()

static func new_initial_state(width: int, height: int) -> MCTSPanelState:
	# Start might we fully random, though I feel like more interesting patterns would emerge from having it on the side
	var start: Vector2 = RNG_UTIL.rand_vec2(1, ((height + 1) / 2)) * 2
	# TODO: Implement
	return MCTSPanelState.new(width, height, [start], false)

func copy(line: Array[Vector2], new_could_place_tetromino) -> MCTSPanelState:
	return MCTSPanelState.new(width, height, line, new_could_place_tetromino)

func move_to(args: Dictionary) -> MCTSPanelState:
	var appended_line: Array[Vector2] = line.duplicate(true)
	var last_pre: Vector2 = line[line.size() - 1]
	appended_line.append(args["dest"])
	var last_post: Vector2 = line[line.size() - 1]
	# If we move from inside the board to the edge, we want to place tetromino next
	var new_could_place_teromino: bool = not _is_on_borders(last_pre) and _is_on_borders(last_post)
	return self.copy(appended_line, new_could_place_teromino)

func place_tetromino(args: Dictionary) -> MCTSPanelState:
	return self.copy(line.duplicate(), false)

func _in_bounds(pos: Vector2) -> bool:
	return pos.clamp(Vector2(0, 0), Vector2(width, height)) == pos

func _is_on_borders(pos: Vector2) -> bool:
	return pos.x == 0 or pos.x == width - 1 or pos.y == 0 or pos.y == height - 1

# =======================
# Abstract functions overrides here

# TODO: Add placing tetromino here
func generate_legal_actions() -> Array:
	return generate_move_actions() + generate_tetromino_actions()

func generate_tetromino_actions() -> Array:
	if not could_place_tetromino:
		return []
	# TODO: Implement
	return []

func generate_move_actions() -> Array:
	var curr_pos: Vector2 = line[line.size() - 1]
	var dest_positions: Array = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]\
		.map(func(unit_vec: Vector2): return curr_pos + unit_vec * 2)\
		.filter(func(next: Vector2): return !line.has(next) && _in_bounds(next))
	return dest_positions.map(func(dest: Vector2): return MCTSAction.new(Callable(self, "move_to"), {"dest": dest}))


func legal_actions() -> Array:
	return curr_legal_actions

# TODO: It would be best to somehow return number of solutions
# TODO: BTW - maybe it should only return once the generation is finished? In order to only compare final results
#   The basic implementation of MCTS is probably wrong actually
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
