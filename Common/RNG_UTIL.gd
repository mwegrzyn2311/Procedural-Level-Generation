extends Node

var RNG = RandomNumberGenerator.new()
var seed: int = 0: set = set_seed, get = get_seed

var generation_state: int = 0

func _ready():
	RNG.randomize()
	self.seed = RNG.get_seed()
	
func set_seed(new_seed: int) -> void:
	if new_seed != -1:
		RNG.set_seed(new_seed)
	else:
		RNG.randomize()
	seed = RNG.get_seed()
	
func get_seed() -> int:
	return seed

func rand_vec2(width: int, height: int) -> Vector2:
	var x = self.RNG.randi_range(0, width - 1)
	var y = self.RNG.randi_range(0, height - 1)
	return Vector2(x, y)
	
func rand_bool() -> bool:
	if RNG.randi_range(0,1) == 0:
		return false
	else:
		return true

func choice(arr: Array):
	if arr.is_empty():
		return null
	return arr[RNG.randi_range(0, arr.size() - 1)]
	
func save_generation_state():
	self.generation_state = RNG.state
	
func restore_randomness():
	RNG.state = generation_state

func change_seed_to_random():
	set_seed(-1)

func rand_pos_neg() -> int:
	if RNG.randi_range(0,1) == 0:
		return -1
	else:
		return 1
