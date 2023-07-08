extends MCTSLevelGenerator

class_name SupaplexMCTSLevelGenerator

var width: int
var height: int

func _init(width: int, height: int):
	self.width = width
	self.height = height

func generate_level() -> Dictionary:
	print("Genrating Supaplex using MCTS")
	var _unused = super.generate_level()
	var res: Dictionary = generate(MCTSSupaplexState.new_initial_state(width, height))
	print("Finished")
	return res
