extends MCTSLevelGenerator

class_name SupaplexMCTSLevelGenerator

var width: int
var height: int

func _init(width: int, height: int):
	self.width = width
	self.height = height

func generate_level() -> Dictionary:
	var _unused = super.generate_level()
	return generate(MCTSSupaplexState.new(width, height))
