extends MCTSGameState

class_name MCTSSupaplexState

var initial_player_pos: Vector2
var player_pos: Vector2
# Dictionary[Vector2, TILE_ELEMENTS.Ele]
var map: Dictionary
var falling_eles_at: Array[Vector2]
# Dictionary[Vector2, TILE_ELEMENTS.Ele]
var placed_elements: Dictionary
var moves_remaining: int
var ded: bool
var waiting_actions: int
var curr_legal_actions: Array
var prev_pos: Vector2
var has_pushed: bool

func _init(initial_player_pos: Vector2, player_pos: Vector2, map: Dictionary, falling_eles_at: Array[Vector2],\
		placed_elements: Dictionary, moves_remaining: int, ded: bool, waiting_actions: int, prev_pos: Vector2, has_pushed: bool):
	self.initial_player_pos = initial_player_pos
	self.player_pos = player_pos
	self.map = map
	self.falling_eles_at = falling_eles_at
	self.placed_elements = placed_elements
	self.moves_remaining = moves_remaining
	self.ded = ded
	self.waiting_actions = waiting_actions
	self.curr_legal_actions = self._generate_legal_actions()
	self.curr_legal_actions.shuffle()
	self.prev_pos = prev_pos
	self.has_pushed = has_pushed

static func _initial_moves(width: int, height: int) -> int:
	return width * height * 2

static func new_initial_state(width: int, height: int) -> MCTSSupaplexState:
	var initial_player_pos: Vector2 = RNG_UTIL.rand_vec2(width, height)
	# TODO: Investigate best initial value for moves_remaining
	var map = {}
	for y in range(height):
		for x in range(width):
			map[Vector2(x, y)] = TILE_ELEMENTS.Ele.WALL
	map[initial_player_pos] = TILE_ELEMENTS.Ele.PLAYER
	return MCTSSupaplexState.new(initial_player_pos, initial_player_pos, map,\
		[], {}, _initial_moves(width, height), false, 0, initial_player_pos, false)

func copy(new_player_pos: Vector2, new_map: Dictionary, new_falling_eles_at: Array[Vector2], new_placed_elements: Dictionary,\
new_ded: bool, new_waiting_actions: int, prev_pos: Vector2, new_has_pushed: bool) -> MCTSSupaplexState:
	return MCTSSupaplexState.new(initial_player_pos, new_player_pos, new_map, new_falling_eles_at, new_placed_elements,
		moves_remaining - 1, new_ded, new_waiting_actions, prev_pos, new_has_pushed)

func move_player(args: Dictionary) -> MCTSSupaplexState:
	var dest = player_pos + args["dir"]
	var new_placed_elements: Dictionary = placed_elements.duplicate(true)
	if player_pos not in new_placed_elements:
		new_placed_elements[player_pos] = args["ele_to_place"]
	var new_map = map.duplicate(true)
	if new_map[dest] == TILE_ELEMENTS.Ele.WALL:
		new_map[dest] = TILE_ELEMENTS.Ele.EMPTY
	var new_falling_eles_at = falling_eles_at.duplicate(true)
	var sim_res: SUPAPLEX_UTILS.SimRes = SUPAPLEX_UTILS.simulate_one_turn_opt(new_map, new_map.duplicate(true), new_falling_eles_at, falling_eles_at, player_pos, dest, CURRENT_LEVEL_INFO.width, CURRENT_LEVEL_INFO.height)
	return copy(dest, new_map, new_falling_eles_at, new_placed_elements, sim_res == SUPAPLEX_UTILS.SimRes.FAIL, waiting_actions, player_pos, (has_pushed || SUPAPLEX_UTILS.SimRes.PUSH))

func stay_still(args: Dictionary) -> MCTSSupaplexState:
	var new_map = map.duplicate(true)
	var new_falling_eles_at = falling_eles_at.duplicate(true)
	var sim_res: SUPAPLEX_UTILS.SimRes = SUPAPLEX_UTILS.simulate_one_turn_opt(new_map, map, new_falling_eles_at, falling_eles_at, player_pos, player_pos, CURRENT_LEVEL_INFO.width, CURRENT_LEVEL_INFO.height)
	return copy(player_pos, new_map, new_falling_eles_at, placed_elements.duplicate(true), sim_res == SUPAPLEX_UTILS.SimRes.FAIL, waiting_actions + 1, prev_pos, has_pushed)

func place_boulder(args: Dictionary) -> MCTSSupaplexState:
	var boulder_pos: Vector2 = args["boulder_pos"]
	var new_placed_elements = placed_elements.duplicate(true)
	new_placed_elements[boulder_pos] = TILE_ELEMENTS.Ele.BOULDER
	var new_falling_eles_at = falling_eles_at.duplicate(true)
	var new_map = map.duplicate(true)
	new_map[boulder_pos] = TILE_ELEMENTS.Ele.BOULDER
	return self.copy(player_pos, new_map, new_falling_eles_at, new_placed_elements, ded, waiting_actions, prev_pos, has_pushed)

func finish_generation():
	placed_elements[initial_player_pos] = TILE_ELEMENTS.Ele.PLAYER
	if initial_player_pos == player_pos:
		placed_elements[prev_pos] = TILE_ELEMENTS.Ele.EXIT
	else:
		placed_elements[player_pos] = TILE_ELEMENTS.Ele.EXIT
	for pos in placed_elements:
		if placed_elements[pos] == TILE_ELEMENTS.Ele.BOULDER:
			var below: Vector2 = pos + Vector2.DOWN
			if SUPAPLEX_UTILS.in_bounds(below) and not below in placed_elements:
				placed_elements[below] = TILE_ELEMENTS.Ele.GRASS

# =======================
# Abstract functions overrides here

func legal_actions() -> Array:
	return curr_legal_actions

func _generate_legal_actions() -> Array:
	var curr_legal_move_actions: Array[MCTSAction] = legal_move_actions()
	if curr_legal_move_actions.is_empty():
		self.ded = true
		return []
	return curr_legal_move_actions + legal_stay_still_actions() + legal_boulder_actions()

func _is_element(pos: Vector2, ele: TILE_ELEMENTS.Ele) -> bool:
	return self.placed_elements.has(pos) and self.placed_elements[pos] == ele

func _is_one_of_elements(pos: Vector2, eles: Array[TILE_ELEMENTS.Ele]) -> bool:
	return self.placed_elements.has(pos) and eles.has(self.placed_elements[pos])

func _is_fallable(pos: Vector2):
	return self.placed_elements.has(pos) and TILE_ELEMENTS.is_fallable(self.placed_elements[pos])

func legal_move_actions() -> Array[MCTSAction]:
	var legal_move_actions: Array[MCTSAction] = []
	SUPAPLEX_UTILS.ELEMENTS_TO_PLACE.shuffle()
	for i in range(4):
		var unit_vector: Vector2 = CONSTANTS.UNIT_VECTORS[i]
		var dest: Vector2 = player_pos + unit_vector
		var above_dest: Vector2 = dest + Vector2.UP
		if SUPAPLEX_UTILS.in_bounds(dest) and map[dest] != TILE_ELEMENTS.Ele.BOULDER and not above_dest in falling_eles_at:
			var ele_to_place = SUPAPLEX_UTILS.ELEMENTS_TO_PLACE[i]
			legal_move_actions.append(MCTSAction.new(Callable(self, "move_player"), {"dir": unit_vector, "ele_to_place": ele_to_place}))
	return legal_move_actions

# TODO: Might consider calculating how many times it's necesary to clear level
func legal_stay_still_actions() -> Array[MCTSAction]:
	var above: Vector2 = player_pos + Vector2.UP
	# That would just result in death so why not prevent it?
	if above in falling_eles_at:
		return []
	return [MCTSAction.new(Callable(self, "stay_still"), {})]

func legal_boulder_actions() -> Array[MCTSAction]:
	var res: Array[MCTSAction] = []
	SUPAPLEX_UTILS.PLAYER_PROXIMITY.shuffle()
	for offset in SUPAPLEX_UTILS.PLAYER_PROXIMITY:
		var pos: Vector2 = player_pos + offset
		var below: Vector2 = pos + Vector2.DOWN
		if pos in map and pos not in placed_elements and not (below in map and map[below] == TILE_ELEMENTS.Ele.EMPTY):
			var neighbouring_boulders: int = CONSTANTS.UNIT_VECTORS\
				.map(func(unit_vec: Vector2) -> Vector2: return pos + unit_vec)\
				.filter(func(potential_boulder: Vector2) -> bool: return potential_boulder in placed_elements and placed_elements[potential_boulder] == TILE_ELEMENTS.Ele.BOULDER)\
				.size()
			if neighbouring_boulders < 2:
				res.append(MCTSAction.new(Callable(self, "place_boulder"), {"boulder_pos": pos}))
		if res.size() == 1:
			return res
	return res

static func _rescale(val: float, max_x: float) -> float:
	if val >= max_x * 2:
		return 0.0
	return val * (max_x * 2 - val) / (max_x * max_x)

func generation_result() -> float:
	if not has_pushed:
		return 0.0
	var placed_points = placed_elements.values()\
		.filter(func(ele: TILE_ELEMENTS.Ele) -> int: return ele == TILE_ELEMENTS.Ele.POINT)\
		.size()
	var placed_boulders = placed_elements.values()\
		.filter(func(ele: TILE_ELEMENTS.Ele) -> int: return ele == TILE_ELEMENTS.Ele.BOULDER)\
		.size()
	var max = _initial_moves(CURRENT_LEVEL_INFO.width, CURRENT_LEVEL_INFO.height)
	var other = max - (placed_points + placed_boulders + waiting_actions)
	
	var res = _rescale(float(placed_points)/max, 0.25) * _rescale(float(placed_boulders)/max, 0.25)\
		* _rescale(float(waiting_actions)/max, 0.25) * _rescale(float(other)/max, 0.25)
	return res
	
func max_score() -> float:
	return 1.0

func is_generation_completed() -> bool:
	if ded or moves_remaining == 0:
		finish_generation()
		return true
	return false

func get_level_dict() -> Dictionary:
	var res: Dictionary = {}
	for y in range(CURRENT_LEVEL_INFO.height):
		for x in range(CURRENT_LEVEL_INFO.width):
			res[Vector2(x, y)] = TILE_ELEMENTS.Ele.WALL
	for pos in placed_elements:
		res[pos] = placed_elements[pos]
	return res
