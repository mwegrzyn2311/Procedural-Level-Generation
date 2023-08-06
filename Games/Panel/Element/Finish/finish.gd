extends PanelEle

class_name PanelFinish

func _on_mouse_entered():
	board.register_curr_over(self)

func _on_mouse_exited():
	board.curr_over_exited(self)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		board.check_finish(self)

static func getScene() -> Resource:
	return load("res://Games/Panel/Element/Finish/finish.tscn")
