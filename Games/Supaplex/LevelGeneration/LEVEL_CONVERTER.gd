extends Node

var STR_TO_TILE: Dictionary = {
	"wall": TILE_ELEMENTS.WALL,
	"grass": TILE_ELEMENTS.GRASS,
	"boulder": TILE_ELEMENTS.BOULDER,
	"point": TILE_ELEMENTS.POINT,
	"player": TILE_ELEMENTS.PLAYER,
}

func vec_string_dict_to_tile_arr(vec_string_dict) -> Array:
	return vec_string_dict_to_tile_arr_with_offset(vec_string_dict, Vector2(0,0))

func vec_string_dict_to_tile_arr_with_offset(vec_string_dict, offset: Vector2) -> Array:
	var res: Array = []
	for index_vec2 in vec_string_dict:
		if vec_string_dict[index_vec2] != "empty":
			res.append(TILEMAP_UTILS.ele_instance(STR_TO_TILE[vec_string_dict[index_vec2].to_lower()], index_vec2 + offset))

	return res
