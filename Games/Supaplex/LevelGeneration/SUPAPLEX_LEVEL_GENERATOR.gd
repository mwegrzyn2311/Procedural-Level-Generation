extends Node

var Player = preload("res://Games/Supaplex/Elements/Player/player.tscn")

func generate_level(width: int, height: int, difficulty: int) -> Array:
	# Hardcoded array for testing purposes
	return [
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.PLAYER, Vector2(1,1)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.WALL, Vector2(5,5)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.WALL, Vector2(7,5)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.WALL, Vector2(5,6)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.WALL, Vector2(7,6)),
	]
