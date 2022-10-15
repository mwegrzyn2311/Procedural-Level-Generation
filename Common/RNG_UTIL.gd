extends Node

var RNG = RandomNumberGenerator.new()
var seed: int = 0

func _ready():
	RNG.randomize()
	self.seed = RNG.get_seed()
	
func set_seed(new_seed: int):
	RNG.set_seed(new_seed)
	self.seed = RNG.get_seed()
