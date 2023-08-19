extends Node2D

# This class is used to generate tetromino sprites in one scene for documentation purposes

const OFFSET: Vector2 = Vector2(128,128)

func _ready():
	var i = 0
	for type in TETROMINO_UTIL.types_arr:
		var element: TetrominoEle = TetrominoEle.getScene().instantiate()
		var coord: Vector2 = Vector2(i, 0)
		element.initialize(null, coord, coord_to_position(coord), true, type)
		self.add_child(element)
		i += 1

func coord_to_position(coord: Vector2) -> Vector2:
	return OFFSET + PANEL_ELEMENTS.PIPE_LEN * coord * PANEL_ELEMENTS.ELE_SIZE * PANEL_ELEMENTS.ELE_SCALE

