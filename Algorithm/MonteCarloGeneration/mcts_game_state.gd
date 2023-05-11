extends Node

class_name MCTSGameState


func move(action: MCTSAction) -> MCTSGameState:
	return action.apply()

# =======================
# Abstract functions here
	
func legal_actions() -> Array:
	return []

func generation_result() -> float:
	return -1.0

func is_generation_completed() -> bool:
	return false
	
func get_level_dict() -> Dictionary:
	return {}
