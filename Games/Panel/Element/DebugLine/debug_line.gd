extends PanelEle

class_name DebugLine

const SCENE = preload("res://Games/Panel/Element/DebugLine/debug_line.tscn")

func _ready():
	if not (int(board_coord.x) % 2 == 0 and int(board_coord.y) % 2 == 0):
		self.apply_scale(Vector2(PANEL_ELEMENTS.PIPE_LEN, 1))

func initialize(board: PanelBoard, board_coord: Vector2, coords: Vector2, is_vertical: bool = false):
	super.initialize(board, board_coord, coords, is_vertical)
	if not (int(board_coord.x) % 2 == 0 and int(board_coord.y) % 2 == 0):
		offset_by_half_pipe_len(is_vertical)
		if is_vertical:
			rotate_to_vertical()

func rotate_to_vertical():
	self.set_rotation_degrees(90)
	
func offset_by_half_pipe_len(is_vertical: bool = false):
	if is_vertical:
		self.position.y += PANEL_ELEMENTS.HALF_PIPE_OFFSET
	else:
		self.position.x += PANEL_ELEMENTS.HALF_PIPE_OFFSET

static func getScene() -> Resource:
	return SCENE
