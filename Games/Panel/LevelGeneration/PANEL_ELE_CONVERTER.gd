extends Node

const OFFSET: Vector2 = PANEL_ELEMENTS.ELE_SIZE * Vector2.ONE
const NEIGH_DIST: float = (PANEL_ELEMENTS.PIPE_LEN + 1) * PANEL_ELEMENTS.ELE_SIZE * PANEL_ELEMENTS.ELE_SCALE

# ele is usally of type PANEL_ELEMENTS.Ele, however might also be of type Tetromino
func convert(ele, pos: Vector2, board: PanelBoard) -> PanelEle:
	# TODO: Should refactor this. This is a very ugly workaround
	if ele is Tetromino:
		var element: TetrominoEle = TetrominoEle.getScene().instantiate()
		element.initialize(board, pos, coord_to_position(pos), int(pos.y) % 2 == 1, ele.type)
		return element
	if not PANEL_ELEMENTS.ELE_TO_SCENE.has(ele):
		return null
	var element: PanelEle = PANEL_ELEMENTS.ELE_TO_SCENE[ele].getScene().instantiate()
	element.initialize(board, pos, coord_to_position(pos), int(pos.y) % 2 == 1)
	return element
	
func coord_to_position(coord: Vector2) -> Vector2:
	return OFFSET + move_vec_by_pipe_len(coord) * PANEL_ELEMENTS.ELE_SIZE * PANEL_ELEMENTS.ELE_SCALE

func position_to_coord(pos: Vector2) -> Vector2:
	return (pos - OFFSET) / (PANEL_ELEMENTS.ELE_SIZE * PANEL_ELEMENTS.ELE_SCALE)

func move_vec_by_pipe_len(pos: Vector2) -> Vector2:
	return Vector2(move_int_by_pipe_len(pos.x), move_int_by_pipe_len(pos.y))
	
func move_int_by_pipe_len(coord: int) -> int:
	return (coord / 2) * (PANEL_ELEMENTS.PIPE_LEN - 1) + coord
