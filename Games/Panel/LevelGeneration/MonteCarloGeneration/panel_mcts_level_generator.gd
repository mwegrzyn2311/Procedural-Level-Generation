extends MCTSLevelGenerator

class_name PanelMCTSLevelGenerator

var width: int
var height: int

func _init(width: int, height: int):
	self.width = width
	self.height = height

func generate_level() -> Dictionary:
	var _unused = super.generate_level()
	return generate(MCTSPanelState.new_initial_state(width, height))
