extends Node

class_name MCTSLevelGenerator

func generate_level(initial_state: MCTSGameState) -> Dictionary:
	var selected_node: MCTSNode = initial_state.best_action()
	return selected_node.state.res
