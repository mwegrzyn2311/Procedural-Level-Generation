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

var ELE_TO_SCENE: Dictionary = {
	Ele.PLAYER: preload("res://Games/Supaplex/Elements/Player/player.tscn"),
	Ele.WALL: preload("res://Games/Supaplex/Elements/Wall/wall.tscn"),
	Ele.OBELISK: preload("res://Games/Supaplex/Elements/Obelisk/obelisk.tscn"),
	Ele.BOULDER: preload("res://Games/Supaplex/Elements/Boulder/boulder.tscn"),
	Ele.GRASS: preload("res://Games/Supaplex/Elements/Grass/grass.tscn"),
	Ele.POINT: preload("res://Games/Supaplex/Elements/Point/point.tscn"),
	Ele.EXIT: preload("res://Games/Supaplex/Elements/Exit/exit.tscn"),
}
