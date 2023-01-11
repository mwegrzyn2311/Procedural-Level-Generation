extends Node


func vec_string_dict_to_tile_arr(vec_ele_dict) -> Array:
	return vec_string_dict_to_tile_arr_with_offset(vec_ele_dict, Vector2(0,0))

func vec_string_dict_to_tile_arr_with_offset(vec_ele_dict, offset: Vector2) -> Array:
	var res: Array = []
	for index_vec2 in vec_ele_dict:
		if vec_ele_dict[index_vec2] != TILE_ELEMENTS.Ele.EMPTY:
			res.append(TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.ELE_TO_SCENE[vec_ele_dict[index_vec2]], index_vec2 + offset))
	
	return res
