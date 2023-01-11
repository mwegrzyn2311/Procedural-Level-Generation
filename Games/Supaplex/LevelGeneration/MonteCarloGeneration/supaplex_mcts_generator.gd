extends MCTSLevelGenerator

var width: int
var height: int

func _init(width: int, height: int):
	self.width = width
	self.height = height

func generate() -> Dictionary:
	return generate_level(MCTSSupaplexState.new(width, height))
