extends Node

var STR_TO_TILE: Dictionary = {
	"wall": TILE_ELEMENTS.WALL,
	"grass": TILE_ELEMENTS.GRASS,
	"boulder": TILE_ELEMENTS.BOULDER,
	"point": TILE_ELEMENTS.POINT,
	"player": TILE_ELEMENTS.PLAYER,
}

func vec_string_dict_to_tile_arr(vec_string_dict) -> Array:
	var res: Array = []
	for index in vec_string_dict:
		if vec_string_dict[index] != "empty":
			res.append(TILEMAP_UTILS.ele_instance(STR_TO_TILE[vec_string_dict[index]], index))
		
	return res
