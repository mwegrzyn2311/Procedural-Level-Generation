extends SpinBox
class_name NumericInput


func _ready():
	adjust_style()
	
func adjust_style():
	get_line_edit().add_theme_font_size_override("IncFontSize", 48)
	get_line_edit().add_theme_font_override("SetFontRoboto", load("res://Fonts/Roboto-Medium.ttf"))

func get_int_value() -> int:
	return int(get_value())
