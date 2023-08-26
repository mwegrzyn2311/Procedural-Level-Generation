extends Button


func _on_pressed():
	RNG_UTIL.change_seed_to_random()
	get_node("../../SeedLabel").redraw_seed_label()
	NAVIGATION.game_scene.regenerate_level()
	NAVIGATION.game_overlay.disable_completion_overlay_visibility()
