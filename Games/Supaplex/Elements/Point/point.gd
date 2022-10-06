extends MovableElement

var VALUE: int = 1

func has_been_eaten():
	super.has_been_eaten()
	CURRENT_LEVEL_INFO.inc_collected_points(self.VALUE)
