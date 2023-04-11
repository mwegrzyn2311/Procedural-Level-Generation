extends Node2D

class_name Board

@onready var panel_elements = $Elements
@onready var start = $Elements/Start
@onready var line: Line = Line.new()

var is_drawing: bool = false
var last_drawing_origin: Vector2

func _ready():
	self.add_child(line)
	_reset_line()
	call_deferred("register_in_navigation")

func _process(delta):
	if is_drawing:
		line.set_point_position(line.get_point_count() - 1, get_local_mouse_position())
	
func register_in_navigation():
	NAVIGATION.game_scene = self

func generate_elements():
	CURRENT_PANEL.generate_map()
	for element in CURRENT_LEVEL_INFO.level_map:
		panel_elements.add_child(element)
		element.add_to_group("panel_elements")
		
func cleanup():
	_reset_line()
	for element in panel_elements.get_children():
		panel_elements.remove_child(element)
		
func regenerate_level():
	cleanup()
	generate_elements()


func _reset_line():
	line.clear_points()
	last_drawing_origin = start.position
	line.add_point(last_drawing_origin)
	line.add_point(last_drawing_origin)
	
func _turn(intersection_pos):
	last_drawing_origin = intersection_pos
	line.add_point(intersection_pos)

func _start_drawing():
	if is_drawing:
		pass
	is_drawing = true

func _end_drawing():
	is_drawing = false
	_reset_line()

func _on_start_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		_start_drawing()

func _on_background_gui_input(event):
	if event is InputEventMouseButton:
		_end_drawing()




func _on_intersection_mouse_entered():
	pass # Replace with function body.
