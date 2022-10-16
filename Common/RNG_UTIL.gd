extends Node

var RNG = RandomNumberGenerator.new()
var seed: int = 0

func _ready():
	RNG.randomize()
	self.seed = RNG.get_seed()
	
func set_seed(new_seed: int):
	RNG.set_seed(new_seed)
	self.seed = RNG.get_seed()

func rand_vec2(width: int, height: int):
	var x = self.RNG.randi_range(0, width - 1)
	var y = self.RNG.randi_range(0, height - 1)
	return Vector2(x, y)
