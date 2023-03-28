extends Button

#@onready var seedLabel = get_tree().current_scene.owner.owner.owner.get_node("SeedLabel")

func _on_pressed():
	RNG_UTIL.change_seed_to_random()
	get_node("../../SeedLabel").redraw_seed_label()
	NAVIGATION.game_scene.regenerate_level()
