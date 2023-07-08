extends PanelEle

class_name PanelIntersection

const SCENE = preload("res://Games/Panel/Element/Intersection/intersection.tscn")

func _on_mouse_entered():
	board.register_curr_over(self)

func _on_mouse_exited():
	board.curr_over_exited(self)
