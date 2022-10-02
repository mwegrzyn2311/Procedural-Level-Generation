extends Node

var Player = preload("res://Games/Supaplex/Elements/Player/player.tscn")

func generate_level(width: int, height: int, difficulty: int) -> Array:
	var player = Player.instantiate()
	player.set_coords(Vector2(0, 0))
	return [player]
