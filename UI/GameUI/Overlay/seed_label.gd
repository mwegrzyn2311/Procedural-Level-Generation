extends Label

func _ready():
	redraw_seed_label()

func redraw_seed_label():
	self.text = "Seed\n%d" % RNG_UTIL.get_seed()
