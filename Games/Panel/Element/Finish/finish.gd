extends PanelEle

class_name PanelFinish

#const SCENE = preload("res://Games/Panel/Element/Finish/finish.tscn")

func _on_mouse_entered():
	board.register_curr_over(self)

func _on_mouse_exited():
	board.curr_over_exited(self)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		board.check_finish(self)
