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

func _init(initial_player_pos: Vector2, player_pos: Vector2, map: Dictionary, falling_eles_at: Array[Vector2],\
		placed_elements: Dictionary, moves_remaining: int, ded: bool, waiting_actions: int, prev_pos: Vector2):
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

static func _initial_moves(width: int, height: int) -> int:
	return width * height

static func new_initial_state(width: int, height: int) -> MCTSSupaplexState:
	var initial_player_pos: Vector2 = RNG_UTIL.rand_vec2(width, height)
	# TODO: Investigate best initial value for moves_remaining
	var map = {}
	for y in range(height):
		for x in range(width):
			map[Vector2(x, y)] = TILE_ELEMENTS.Ele.WALL
	map[initial_player_pos] = TILE_ELEMENTS.Ele.PLAYER
	return MCTSSupaplexState.new(initial_player_pos, initial_player_pos, map,\
		[], {}, _initial_moves(width, height), false, 0, initial_player_pos)

func copy(new_player_pos: Vector2, new_map: Dictionary, new_falling_eles_at: Array[Vector2],\
	new_placed_elements: Dictionary, new_ded: bool, new_waiting_actions: int, prev_pos: Vector2) -> MCTSSupaplexState:
	return MCTSSupaplexState.new(initial_player_pos, new_player_pos, new_map, new_falling_eles_at, new_placed_elements,
		moves_remaining - 1, new_ded, new_waiting_actions, prev_pos)

func move_player(args: Dictionary) -> MCTSSupaplexState:
	var dest = player_pos + args["dir"]
	var new_placed_elements: Dictionary = placed_elements.duplicate(true)
	if player_pos not in new_placed_elements:
		new_placed_elements[player_pos] = args["ele_to_place"]
	var new_map = map.duplicate(true)
	if new_map[dest] == TILE_ELEMENTS.Ele.WALL:
		new_map[dest] = TILE_ELEMENTS.Ele.EMPTY
	var new_falling_eles_at = falling_eles_at.duplicate(true)
	var new_ded: bool = not SUPAPLEX_UTILS.simulate_one_turn_opt(new_map, new_map.duplicate(true), new_falling_eles_at, falling_eles_at, player_pos, dest, CURRENT_LEVEL_INFO.width, CURRENT_LEVEL_INFO.height)
	return copy(dest, new_map, new_falling_eles_at, new_placed_elements, new_ded, waiting_actions, player_pos)

func stay_still(args: Dictionary) -> MCTSSupaplexState:
	var new_map = map.duplicate(true)
	var new_falling_eles_at = falling_eles_at.duplicate(true)
	var new_ded: bool = not SUPAPLEX_UTILS.simulate_one_turn_opt(new_map, map, new_falling_eles_at, falling_eles_at, player_pos, player_pos, CURRENT_LEVEL_INFO.width, CURRENT_LEVEL_INFO.height)
	return copy(player_pos, new_map, new_falling_eles_at, placed_elements.duplicate(true), new_ded, waiting_actions + 1, prev_pos)

func place_boulder(args: Dictionary) -> MCTSSupaplexState:
	var boulder_pos: Vector2 = args["boulder_pos"]
	var new_placed_elements = placed_elements.duplicate(true)
	new_placed_elements[boulder_pos] = TILE_ELEMENTS.Ele.BOULDER
	var new_falling_eles_at = falling_eles_at.duplicate(true)
	var new_map = map.duplicate(true)
	new_map[boulder_pos] = TILE_ELEMENTS.Ele.BOULDER
	return self.copy(player_pos, new_map, new_falling_eles_at, new_placed_elements, ded, waiting_actions, prev_pos)

func finish_generation():
	placed_elements[initial_player_pos] = TILE_ELEMENTS.Ele.PLAYER
	if initial_player_pos == player_pos:
		placed_elements[prev_pos] = TILE_ELEMENTS.Ele.EXIT
	else:
		placed_elements[player_pos] = TILE_ELEMENTS.Ele.EXIT

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
		if SUPAPLEX_UTILS.in_bounds(dest) and map[dest] != TILE_ELEMENTS.Ele.BOULDER:
			var ele_to_place = SUPAPLEX_UTILS.ELEMENTS_TO_PLACE[i]
			legal_move_actions.append(MCTSAction.new(Callable(self, "move_player"), {"dir": unit_vector, "ele_to_place": ele_to_place}))
	return legal_move_actions

# TODO: Might consider calculating how many times it's necesary to clear level
func legal_stay_still_actions() -> Array[MCTSAction]:
	return [MCTSAction.new(Callable(self, "stay_still"), {})]

func legal_boulder_actions() -> Array[MCTSAction]:
	var res: Array[MCTSAction] = []
	SUPAPLEX_UTILS.PLAYER_PROXIMITY.shuffle()
	for offset in SUPAPLEX_UTILS.PLAYER_PROXIMITY:
		var pos: Vector2 = player_pos + offset
		var below: Vector2 = pos + Vector2.DOWN
		if pos in map and pos not in placed_elements and not (below in map and map[below] == TILE_ELEMENTS.Ele.EMPTY):
			res.append(MCTSAction.new(Callable(self, "place_boulder"), {"boulder_pos": pos}))
		if res.size() == 4:
			return res
	return res

static func _rescale(val: float) -> float:
	if val >= 0.5:
		return 0.0
	return val * (0.5 - val)
	#return pow(2 * val + 1, 3) * pow(1 - val, 3)

func generation_result() -> float:
	var placed_points = placed_elements.values()\
		.filter(func(ele: TILE_ELEMENTS.Ele) -> int: return ele == TILE_ELEMENTS.Ele.POINT)\
		.size()
	var placed_boulders = placed_elements.values()\
		.filter(func(ele: TILE_ELEMENTS.Ele) -> int: return ele == TILE_ELEMENTS.Ele.BOULDER)\
		.size()
	var max = _initial_moves(CURRENT_LEVEL_INFO.width, CURRENT_LEVEL_INFO.height)
	var other = max - (placed_points + placed_boulders + waiting_actions)
	
	var res = _rescale(float(placed_points)/max) * _rescale(float(placed_boulders)/max)\
		* _rescale(float(waiting_actions)/max) * _rescale(float(other)/max)
	return res
	
func max_score() -> float:
	return pow(_rescale(0.25), 4)

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
