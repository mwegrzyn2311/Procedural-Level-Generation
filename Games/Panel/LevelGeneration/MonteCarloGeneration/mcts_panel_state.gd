extends MCTSGameState

class_name MCTSPanelState

var width: int
var height: int

var line: Array[Vector2]
# Keep it in var instead of calculating to optimize
var curr_legal_actions: Array;

func _init(width: int, height: int, line: Array[Vector2]):
	self.width = width
	self.height = height
	self.line = line
	self.curr_legal_actions = self.generate_legal_actions()

static func new_initial_state(width: int, height: int) -> MCTSPanelState:
	# Start might we fully random, though I feel like more interesting patterns would emerge from having it on the side
	var start: Vector2 = RNG_UTIL.rand_vec2(0, 2 * ((height + 1) / 2))
	# TODO: Implement
	return MCTSPanelState.new(width, height, [start])

func copy(line: Array[Vector2]) -> MCTSPanelState:
	return MCTSPanelState.new(width, height, line)

func move_to(args: Dictionary) -> MCTSPanelState:
	var appended_line: Array[Vector2] = line.duplicate(true)
	appended_line.append(args["dest"])
	return self.copy(appended_line)

func _in_bounds(pos: Vector2) -> bool:
	return pos.clamp(Vector2(0, 0), Vector2(width, height)) == pos

# =======================
# Abstract functions overrides here

func generate_legal_actions() -> Array:
	var curr_pos: Vector2 = line[line.size() - 1]
	var dest_positions: Array = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]\
		.map(func(unit_vec: Vector2): return curr_pos + unit_vec * 2)\
		.filter(func(next: Vector2): return !line.has(next) && _in_bounds(next))
	return dest_positions.map(func(dest: Vector2): return MCTSAction.new(Callable(self, "move_to"), {"dest": dest}))

func legal_actions() -> Array:
	return curr_legal_actions

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
	
	return res
