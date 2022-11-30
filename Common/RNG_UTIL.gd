extends Node

var RNG = RandomNumberGenerator.new()
var seed: int = 0

func _ready():
	RNG.randomize()
	self.seed = RNG.get_seed()
	
func set_seed(new_seed: int) -> void:
	RNG.set_seed(new_seed)
	self.seed = RNG.get_seed()

func rand_vec2(width: int, height: int) -> Vector2:
	var x = self.RNG.randi_range(0, width - 1)
	var y = self.RNG.randi_range(0, height - 1)
	return Vector2(x, y)

func choice(arr: Array):
	return arr[RNG.randi_range(0, arr.size() - 1)]
