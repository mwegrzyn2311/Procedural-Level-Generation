extends Node

enum Ele {
	EMPTY,
	PLAYER,
	WALL,
	OBELISK,
	BOULDER,
	GRASS,
	POINT,
	EXIT
}

const PLAYER_CAN_MOVE_TO: Array[TILE_ELEMENTS.Ele] = [
	TILE_ELEMENTS.Ele.POINT, TILE_ELEMENTS.Ele.GRASS, TILE_ELEMENTS.Ele.EMPTY, TILE_ELEMENTS.Ele.EXIT
]
const FALLABLE_ELEMENTS: Array[TILE_ELEMENTS.Ele] = [TILE_ELEMENTS.Ele.BOULDER, TILE_ELEMENTS.Ele.POINT]

func _can_move_to(ele) -> bool:
	return PLAYER_CAN_MOVE_TO.has(ele)

func is_corridor(ele: Ele) -> bool:
	# Player is above empty so it can be counted as a corridor
	return ele == Ele.GRASS || ele == Ele.EMPTY || ele == Ele.PLAYER || ele == Ele.POINT

func is_fallable(ele: Ele) -> bool:
	return ele == Ele.BOULDER || ele == Ele.POINT

var ELE_TO_SCENE: Dictionary = {
	Ele.PLAYER: preload("res://Games/Supaplex/Elements/Player/player.tscn"),
	Ele.WALL: preload("res://Games/Supaplex/Elements/Wall/wall.tscn"),
	Ele.OBELISK: preload("res://Games/Supaplex/Elements/Obelisk/obelisk.tscn"),
	Ele.BOULDER: preload("res://Games/Supaplex/Elements/Boulder/boulder.tscn"),
	Ele.GRASS: preload("res://Games/Supaplex/Elements/Grass/grass.tscn"),
	Ele.POINT: preload("res://Games/Supaplex/Elements/Point/point.tscn"),
	Ele.EXIT: preload("res://Games/Supaplex/Elements/Exit/exit.tscn"),
}
