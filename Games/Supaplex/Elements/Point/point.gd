extends MovableElement

const VALUE: int = 1

# Because of circular import, cannot reference CURRENT_LEVEL_INFO by just name
@onready var current_level_info = get_node("/root/CURRENT_LEVEL_INFO")


func has_been_eaten():
	super.has_been_eaten()
	current_level_info.inc_collected_points(self.VALUE)

func get_value() -> int:
	return VALUE
