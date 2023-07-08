extends MCTSGameState

class_name MCTSSupaplexState

var width: int
var height: int

var res: Dictionary
var walls_to_delete: int
var points_to_place: int
var initial_player_pos: Vector2
var player_pos: Vector2
var walls_deleted: int
var rocks_placed: int
var points_placed: int

var curr_legal_actions: Array
var curr_legal_move_actions: Array

var gen_res: float

func _init(res: Dictionary, width: int, height: int, walls_to_delete: int, points_to_place: int, initial_player_pos: Vector2, player_pos: Vector2, walls_deleted: int = 0, rocks_placed: int = 0, points_placed: int = 0):
	self.res = res
	self.width = width
	self.height = height
	self.walls_to_delete = walls_to_delete
	self.points_to_place = points_to_place
	self.initial_player_pos = initial_player_pos
	self.player_pos = player_pos
	self.walls_deleted = walls_deleted
	self.rocks_placed = rocks_placed
	self.points_placed = points_placed
	self.generate_legal_actions()
	self.calc_gen_res()
	
static func new_initial_state(width: int, height: int) -> MCTSSupaplexState:
	var res: Dictionary = {}
	for j in range(height):
		for i in range(width):
			res[Vector2(i, j)] = TILE_ELEMENTS.Ele.WALL
	var initial_player_pos = RNG_UTIL.rand_vec2(width, height)
	res[initial_player_pos] = TILE_ELEMENTS.Ele.PLAYER
	var walls_to_delete = int(RNG_UTIL.RNG.randf_range(0.45, 0.55) * width * height)
	var points_to_place = int(RNG_UTIL.RNG.randf_range(0.15, 0.2) * walls_to_delete)
	return MCTSSupaplexState.new(res, width, height, walls_to_delete, points_to_place, initial_player_pos, initial_player_pos)

func copy(res: Dictionary, new_player_pos: Vector2, new_walls_deleted: int, new_rocks_placed: int, new_points_placed: int) -> MCTSSupaplexState:
	return MCTSSupaplexState.new(res, width, height, walls_to_delete, points_to_place, initial_player_pos, new_player_pos, new_walls_deleted, new_rocks_placed, new_points_placed)

const NIEGH_CORRID_MULT: float = 1.0
const NIEGH_DIAG_NON_CORRID_MULT: float = 5.0

func score_at_pos(pos: Vector2) -> float:
	if not TILE_ELEMENTS.is_corridor(res[pos]):
		return 1.0 if res[pos] == TILE_ELEMENTS.Ele.BOULDER else 0.0
	var number_of_neigh_corridors: float = 0.0
	var number_of_diag_neigh_non_corridors: float = 0.0
	for vec in CONSTANTS.UNIT_VECTORS:
		if not res.has(vec) or TILE_ELEMENTS.is_corridor(res[vec]):
			number_of_neigh_corridors += 1.0
	for vec in CONSTANTS.DIAGONAL_UNIT_VECTORS:
		if res.has(vec) and not TILE_ELEMENTS.is_corridor(res[vec]):
			number_of_diag_neigh_non_corridors += 1.0
	return max(1.0, NIEGH_CORRID_MULT * number_of_neigh_corridors + NIEGH_DIAG_NON_CORRID_MULT * number_of_diag_neigh_non_corridors)
	
func max_score_at_pos() -> float:
	return NIEGH_CORRID_MULT * 4.0 + NIEGH_DIAG_NON_CORRID_MULT * 4.0

func move_player(args: Dictionary) -> MCTSSupaplexState:
	var new_res: Dictionary = self.res.duplicate(true)
	var dir: Vector2 = args["dir"]
	var dest: Vector2 = self.player_pos + dir
	assert(self.res.has(dest))
	var new_walls_deleted = walls_deleted + 1 if new_res[dest] == TILE_ELEMENTS.Ele.WALL else walls_deleted
	var ele_to_place = element_to_place()
	new_res[self.player_pos] = ele_to_place
	var new_points_placed: int = points_placed + 1 if ele_to_place == TILE_ELEMENTS.Ele.POINT else points_placed
	new_res[dest] = TILE_ELEMENTS.Ele.PLAYER
	return self.copy(new_res, dest, new_walls_deleted, rocks_placed, new_points_placed)

func element_to_place() -> TILE_ELEMENTS.Ele:
	var point_chance = float(points_to_place - points_placed) / float(walls_to_delete - walls_deleted)
	if RNG_UTIL.RNG.randf() <= point_chance:
		points_placed += 1
		return TILE_ELEMENTS.Ele.POINT
	else:
		return TILE_ELEMENTS.Ele.GRASS

func place_boulder(args: Dictionary) -> MCTSSupaplexState:
	var new_res = res.duplicate(true)
	var dest_ele: TILE_ELEMENTS.Ele = self.res[args["pos"]]
	var new_walls_deleted: int = walls_deleted + 1 if dest_ele == TILE_ELEMENTS.Ele.WALL else walls_deleted
	# TODO: Is the below commented out code needed?
#	if TILE_ELEMENTS.is_corridor(dest_ele):
#		self.walls_deleted -= 1
	new_res[args["pos"]] = TILE_ELEMENTS.Ele.BOULDER
	return self.copy(new_res, Vector2(player_pos), new_walls_deleted, rocks_placed + 1, points_placed)

func finish_generation():
	res[initial_player_pos] = TILE_ELEMENTS.Ele.PLAYER
	res[player_pos] = TILE_ELEMENTS.Ele.EXIT

func generate_legal_actions():
	self.curr_legal_move_actions = legal_move_actions()
	self.curr_legal_actions = self.curr_legal_move_actions + legal_boulder_actions()

func calc_gen_res():
	if walls_to_delete != walls_deleted:
		return -1.0
	var total = 0.0
	for pos in res:
		total += score_at_pos(pos)
	self.gen_res = total / (max_score_at_pos() * self.walls_to_delete)

# =======================
# Abstract functions overrides here
func max_score() -> float:
	return max_score_at_pos() * self.width * self.height

func legal_actions() -> Array:
	return self.curr_legal_actions.duplicate()

func legal_move_actions() -> Array[MCTSAction]:
	var legal_move_actions: Array[MCTSAction] = []
	for unit_vector in CONSTANTS.UNIT_VECTORS:
		var dest: Vector2 = self.player_pos + unit_vector
		if self.res.has(dest) and (self.res[dest] == TILE_ELEMENTS.Ele.WALL or self.res[dest] == TILE_ELEMENTS.Ele.GRASS) and not (self.res.has(dest + Vector2.UP) and self.res[dest + Vector2.UP] == TILE_ELEMENTS.Ele.BOULDER):
			legal_move_actions.append(MCTSAction.new(Callable(self, "move_player"), {"dir": unit_vector}))
	return legal_move_actions

func legal_boulder_actions() -> Array[MCTSAction]:
	var boulder_potential_pos: Vector2 = self.player_pos + Vector2.UP
	if res.has(boulder_potential_pos) and not TILE_ELEMENTS.is_corridor(res[boulder_potential_pos]):
		return [MCTSAction.new(Callable(self, "place_boulder"), {"pos": boulder_potential_pos})]
	else:
		return []

func generation_result() -> float:
	return self.gen_res
	
func is_generation_completed() -> bool:
	if walls_to_delete == walls_deleted || curr_legal_move_actions.is_empty():
		finish_generation()
		return true
	return false

func get_level_dict() -> Dictionary:
	return self.res
