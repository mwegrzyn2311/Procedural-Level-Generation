extends StaticElement

# Because of circular import, cannot reference CURRENT_LEVEL_INFO by just name
@onready var current_level_info = get_node("/root/CURRENT_LEVEL_INFO")

func try_exit() -> void:
	if current_level_info.win_condition_fulfilled():
		self._complete_level()

# TODO: Implement
func _complete_level() -> void:
	print("Level completed")
