extends PanelEle

class_name TetrominoEle

func initialize(board: PanelBoard, board_coord: Vector2, coords: Vector2, is_vertical: bool = false, tetromino_type: TETROMINO_UTIL.Type = 0):
	super.initialize(board, board_coord, coords, is_vertical)
	self.position.y -= ((3 * PANEL_ELEMENTS.ELE_SIZE * PANEL_ELEMENTS.ELE_SCALE / 2 - PANEL_ELEMENTS.HALF_PIPE_OFFSET) / 4)
	self.position.x -= ((3 * PANEL_ELEMENTS.ELE_SIZE * PANEL_ELEMENTS.ELE_SCALE / 2 - PANEL_ELEMENTS.HALF_PIPE_OFFSET) / 4)
	self.add_child(TETROMINO_UTIL.tetromino_sprites[tetromino_type].duplicate())
	
static func getScene() -> Resource:
	return load("res://Games/Panel/Element/Tetromino/tetromino_ele.tscn")
