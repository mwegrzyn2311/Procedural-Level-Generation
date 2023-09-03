extends MCTSGameState

class_name MCTSSupaplexStateV2

# Dictionary[Vector2, TILE_ELEMENTS.Ele]
var placed_elements: Dictionary
var player_pos: Vector2
var moves_remaining: int
var may_place_boulder: bool
var player_pos_history: Array[Vector2]

func _init(placed_elements: Dictionary, player_pos: Vector2, moves_remaining: int, may_place_boulder: bool, player_pos_history: Array[Vector2]):
	self.placed_elements = placed_elements
	self.player_pos = player_pos
	self.moves_remaining = moves_remaining
	self.may_place_boulder = may_place_boulder
	self.player_pos_history = player_pos_history
	self.player_pos_history.append(player_pos)

static func new_initial_state(width: int, height: int) -> MCTSSupaplexState:
	# TODO: Investigate best initial value for moves_remaining
	return MCTSSupaplexState.new({}, RNG_UTIL.rand_vec2(width, height), width * height, false, [])

func copy(placed_elements: Dictionary, player_pos: Vector2, moves_remaining: int, may_place_boulder: bool) -> MCTSSupaplexState:
	return MCTSSupaplexState.new(placed_elements, player_pos, moves_remaining, may_place_boulder, player_pos_history.duplicate(true))

func move_player(args: Dictionary) -> MCTSSupaplexState:
	var dest = player_pos + args["dir"]
	var new_placed_elements = placed_elements.duplicate(true)
	# Should overwrite the previous value because current move is the more recent one so it would be the one to pick this stuff
	new_placed_elements[player_pos] = TILE_ELEMENTS.Ele.EXIT if new_placed_elements.is_empty() else args["ele_to_place"]
	return copy(new_placed_elements, dest, moves_remaining - 1, Dir2.is_vertical(args["dir"]))

func stay_still(args: Dictionary) -> MCTSSupaplexState:
	return copy(placed_elements.duplicate(true), player_pos, moves_remaining - 1, false)

func place_boulder(args: Dictionary) -> MCTSSupaplexState:
	var boulder_pos: Vector2 = player_pos + Vector2.UP
	var new_placed_elements = placed_elements.duplicate(true)
	new_placed_elements[boulder_pos] = TILE_ELEMENTS.Ele.BOULDER
	return self.copy(new_placed_elements, player_pos, moves_remaining - 1, false)

func finish_generation():
	placed_elements[player_pos] = TILE_ELEMENTS.Ele.PLAYER

# =======================
# Abstract functions overrides here

func legal_actions() -> Array:
	var boulder_actions = legal_boulder_actions()
	return boulder_actions if not boulder_actions.is_empty() else legal_move_actions() + legal_stay_still_actions()

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
		# We don't want to eat ele under the rock because that's the requirement to previously place it
		var ele_above: Vector2 = dest + Vector2.UP
		if SUPAPLEX_UTILS.in_bounds(dest) and not _is_one_of_elements(dest, [TILE_ELEMENTS.Ele.BOULDER, TILE_ELEMENTS.Ele.EXIT]) and not _is_fallable(ele_above):
			var ele_to_place = SUPAPLEX_UTILS.ELEMENTS_TO_PLACE[i]
			legal_move_actions.append(MCTSAction.new(Callable(self, "move_player"), {"dir": unit_vector, "ele_to_place": ele_to_place}))
	return legal_move_actions

# TODO: Might consider calculating how many times it's necesary to clear level
func legal_stay_still_actions() -> Array[MCTSAction]:
	return [MCTSAction.new(Callable(self, "stay_still"), {})]

func legal_boulder_actions() -> Array[MCTSAction]:
	if not may_place_boulder or player_pos.y == 0:
		return []
	var previous_player_pos: Vector2 = self.player_pos_history[-2]
	var dest_boulder_pos: Vector2 = previous_player_pos + Vector2.UP
	if placed_elements.has(dest_boulder_pos) and placed_elements[dest_boulder_pos] == TILE_ELEMENTS.Ele.EXIT:
		return []
	var tmp_placed_elements = placed_elements.duplicate(true)
	tmp_placed_elements[dest_boulder_pos] = TILE_ELEMENTS.Ele.BOULDER
	if SUPAPLEX_UTILS.simulate_gameplay(tmp_placed_elements, player_pos_history):
		return [MCTSAction.new(Callable(self, "place_boulder"), {})]
	return []

func generation_result() -> float:
	var placed_points = placed_elements.values()\
		.filter(func(ele: TILE_ELEMENTS.Ele) -> int: return ele == TILE_ELEMENTS.Ele.BOULDER)\
		.size() * 3
	return placed_points
	
func max_score() -> float:
	return float(CURRENT_LEVEL_INFO.width * CURRENT_LEVEL_INFO.height)

func is_generation_completed() -> bool:
	if moves_remaining == 0:
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
