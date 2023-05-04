extends PanelEle

class_name PanelStart

const SCENE = preload("res://Games/Panel/Element/Start/start.tscn")

func initialize(board: PanelBoard, board_coord: Vector2, coords: Vector2, is_vertical: bool = false):
	super.initialize(board, board_coord, coords, is_vertical)
	board.register_start(self)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		board._start_drawing()

func _on_mouse_entered():
	board.register_curr_over(self)

func _on_mouse_exited():
	board.curr_over_exited(self)
