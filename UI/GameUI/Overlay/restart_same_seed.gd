extends Button



func _on_pressed():
	RNG_UTIL.restore_randomness()
	NAVIGATION.game_scene.regenerate_level()
