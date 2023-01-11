extends MCTSGameState

class_name MCTSSupaplexState

var walls_to_delete: int
var player_pos: Vector2

func _init(width: int, height: int):
	super(initial_state(width, height))
	self.walls_to_delete = int(RNG_UTIL.RNG.randf_range(0.33, 0.66) * width * height)

func initial_state(width: int, height: int) -> Dictionary:
	var res: Dictionary = {}
	for j in range(height):
		for i in range(width):
			res[Vector2(i, j)] = TILE_ELEMENTS.WALL
	self.player_pos = RNG_UTIL.rand_vec2(width, height)
	res[self.player_pos] = TILE_ELEMENTS.Ele.PLAYER
	return res

# =======================
# Abstract functions overrides here
func move(action) -> MCTSGameState:
	return null
	
func legal_actions() -> Array:
	return []

func generation_result():
	return null
	
func is_generation_completed() -> bool:
	return false

