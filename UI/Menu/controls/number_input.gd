extends HBoxContainer


@onready var value_label: Label = $Value


func _on_up_pressed():
	value_label.text = str(inc(value_label.text.to_int()))

func _on_down_pressed():
	value_label.text = str(dec(value_label.text.to_int()))


func inc(curr_val):
	return curr_val + 1
	
func dec(curr_val):
	return max(curr_val - 1, 0)
