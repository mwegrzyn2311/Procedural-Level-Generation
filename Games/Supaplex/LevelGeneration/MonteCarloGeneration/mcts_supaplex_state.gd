extends MCTSGameState

class_name MCTSSupaplexState

var walls_to_delete: int
var initial_player_pos: Vector2
var player_pos: Vector2
var walls_deleted: int = 0
var rocks_placed: int = 0

func _init(width: int, height: int):
	super(initial_state(width, height))
	self.walls_to_delete = int(RNG_UTIL.RNG.randf_range(0.35, 0.50) * width * height)

func initial_state(width: int, height: int) -> Dictionary:
	var res: Dictionary = {}
	for j in range(height):
		for i in range(width):
			res[Vector2(i, j)] = TILE_ELEMENTS.Ele.WALL
	self.initial_player_pos = RNG_UTIL.rand_vec2(width, height)
	res[self.initial_player_pos] = TILE_ELEMENTS.Ele.PLAYER
	self.player_pos = initial_player_pos
	return res

func score_at_pos(pos: Vector2) -> float:
	if TILE_ELEMENTS.is_corridor(res[pos]):
		return 1.0 if res[pos] == TILE_ELEMENTS.Ele.BOULDER else 0.0
	var number_of_neigh_corridors = 0
	var number_of_diag_neigh_non_corridors = 0
	for vec in CONSTANTS.UNIT_VECTORS:
		if not res.has(vec) or TILE_ELEMENTS.is_corridor(res[vec]):
			number_of_neigh_corridors += 1.0
	for vec in CONSTANTS.DIAGONAL_UNIT_VECTORS:
		if res.has(vec) and not TILE_ELEMENTS.is_corridor(res[vec]):
			number_of_diag_neigh_non_corridors += 1.0
	return max(1.0, 1.0 * number_of_neigh_corridors + 5.0 * number_of_diag_neigh_non_corridors)

func move_player(args: Dictionary):
	var dest: Vector2 = self.player_pos + args["dir"]
	assert(self.res.has(dest))
	if self.res[dest] == TILE_ELEMENTS.Ele.WALL:
		self.walls_deleted += 1
	self.res[self.player_pos] = TILE_ELEMENTS.Ele.GRASS
	self.res[dest] = TILE_ELEMENTS.Ele.PLAYER
	self.player_pos = dest

func place_boulder(args: Dictionary):
	var dest_ele: TILE_ELEMENTS.Ele = self.res[args["pos"]]
	if TILE_ELEMENTS.is_corridor(dest_ele):
		self.walls_deleted -= 1
	self.res[args["pos"]] = TILE_ELEMENTS.Ele.BOULDER
	rocks_placed += 1

func finish_generation():
	res[initial_player_pos] = TILE_ELEMENTS.Ele.PLAYER
	res[player_pos] = TILE_ELEMENTS.Ele.GRASS

# =======================
# Abstract functions overrides here
func move(action: MCTSAction) -> MCTSGameState:
	action.apply()
	return self
	
func legal_actions() -> Array[MCTSAction]:
	var legal_actions: Array[MCTSAction]
	for unit_vector in CONSTANTS.UNIT_VECTORS:
		if self.res.has(self.player_pos + unit_vector) and not (self.res.has(self.player_pos + unit_vector + Vector2.UP) and self.res[self.player_pos + unit_vector + Vector2.UP] == TILE_ELEMENTS.Ele.BOULDER):
			legal_actions.append(MCTSAction.new(Callable(self, "move_player"), {"dir": unit_vector}))
	var boulder_potential_pos: Vector2 = self.player_pos + Vector2.UP
	if res.has(boulder_potential_pos) and not TILE_ELEMENTS.is_corridor(res[boulder_potential_pos]):
		legal_actions.append(MCTSAction.new(Callable(self, "place_boulder"), {"pos": boulder_potential_pos}))
	return legal_actions

func generation_result() -> float:
	var result = 0.0
	for pos in res:
		result += score_at_pos(pos)
	return result
	
func is_generation_completed() -> bool:
	if walls_to_delete == walls_deleted:
		finish_generation()
		return true
	return false
