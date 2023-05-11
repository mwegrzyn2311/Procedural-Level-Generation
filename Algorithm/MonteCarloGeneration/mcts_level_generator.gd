extends LevelGenerator

class_name MCTSLevelGenerator

func generate(initial_state: MCTSGameState) -> Dictionary:
	var selected_node: MCTSNode = MCTSNode.new(initial_state).best_action()
	return selected_node.state.get_level_dict()
