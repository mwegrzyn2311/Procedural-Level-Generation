extends Button


func _on_pressed():
	DisplayServer.clipboard_set(str(RNG_UTIL.get_seed()))
