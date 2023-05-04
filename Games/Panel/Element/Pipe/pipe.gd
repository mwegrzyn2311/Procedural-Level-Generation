extends PanelEle

class_name PanelPipe

const SCENE = preload("res://Games/Panel/Element/Pipe/pipe.tscn")
const HALF_PIPE_OFFSET = ((PANEL_ELEMENTS.PIPE_LEN - 1) * PANEL_ELEMENTS.ELE_SIZE * PANEL_ELEMENTS.ELE_SCALE) / 2

func _ready():
	self.apply_scale(Vector2(PANEL_ELEMENTS.PIPE_LEN, 1))

func initialize(board: PanelBoard, board_coord: Vector2, coords: Vector2, is_vertical: bool = false):
	super.initialize(board, board_coord, coords, is_vertical)
	offset_by_half_pipe_len(is_vertical)
	if is_vertical:
		rotate_to_vertical()

func rotate_to_vertical():
	self.set_rotation_degrees(90)
	
func offset_by_half_pipe_len(is_vertical: bool = false):
	if is_vertical:
		self.position.y += HALF_PIPE_OFFSET
	else:
		self.position.x += HALF_PIPE_OFFSET
