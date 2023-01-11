extends Node

class_name MCTSGameState


var res: Dictionary

func _init(intial_res: Dictionary):
	self.res = intial_res

# =======================
# Abstract functions here
func move(action) -> MCTSGameState:
	return null
	
func legal_actions() -> Array:
	return []

func generation_result():
	return null

func is_generation_completed() -> bool:
	return false
