extends StaticElement


func try_exit() -> void:
	if CURRENT_LEVEL_INFO.collected_points == CURRENT_LEVEL_INFO.points:
		self._complete_level()

# TODO: Implement
func _complete_level() -> void:
	print("Level completed")
