extends Node2D

class_name PanelBoard

@onready var panel_elements = $Elements
@onready var line: Line = Line.new()

var start: PanelStart
var currently_over: PanelEle = null

var is_drawing: bool = false
var drawing_dir: Vector2 = Vector2.RIGHT

func _ready():
	self.add_child(line)
	_reset_line()
	call_deferred("register_in_navigation")
	regenerate_level()

func _process(delta):
	if not is_drawing:
		return
	if currently_over != null:
		return
	
	line.set_point_position(line.get_point_count() - 1, _line_point_inside_pipe())
	
func _line_point_inside_pipe() -> Vector2:
	var prev_point = line.get_point_position(line.get_point_count() - 2)
	return prev_point + abs(get_local_mouse_position() - prev_point) * self.drawing_dir
	
func register_in_navigation():
	NAVIGATION.game_scene = self

func generate_elements():
	CURRENT_PANEL.generate_map()
	for pos in CURRENT_PANEL.panel_dict:
		var element = PANEL_ELE_CONVERTER.convert(CURRENT_PANEL.panel_dict[pos], pos, self)
		if element != null:
			panel_elements.add_child(element)
			element.add_to_group("panel_elements")

func cleanup():
	_reset_line()
	for element in panel_elements.get_children():
		panel_elements.remove_child(element)
		
func regenerate_level():
	cleanup()
	generate_elements()

func _last_drawing_origin() -> Vector2:
	return line.get_point_position(line.get_point_count() - 2)

func _reset_line():
	line.clear_points()
	var start_pos = Vector2(0,0) if start == null else start.position
	line.add_point(start_pos)
	line.add_point(start_pos)
	
func _turn(intersection_pos: Vector2, mouse_move_dir: Vector2):
	self.drawing_dir = mouse_move_dir
	line.set_point_position(line.get_point_count() - 1, intersection_pos)
	line.add_point(_line_point_inside_pipe())

func _change_dir(mouse_move_dir: Vector2):
	self.drawing_dir = mouse_move_dir

func _go_back(back_dir: Vector2):
	line.remove_point(line.get_point_count() - 2)

func _start_drawing():
	self.register_curr_over(start)
	if is_drawing:
		pass
	is_drawing = true

func _end_drawing():
	is_drawing = false
	_reset_line()

func _on_background_gui_input(event):
	if event is InputEventMouseButton:
		_end_drawing()

func register_start(start: PanelStart):
	self.start = start

func _has_already_been_visited(pos: Vector2):
	var pos_index: int = line.points.find(pos)
	# TODO: Verify that it correct to filter out the last point (in case we get pixel perfect)
	return pos_index != -1 and pos_index != line.points.size() - 1

func has_already_been_visited(ele: PanelEle):
	return _has_already_been_visited(ele.position)

func is_last_visited(ele: PanelEle):
	return ele.position == _last_drawing_origin()

func register_curr_over(currently_over: PanelEle):
	if is_drawing and (is_last_visited(currently_over) or (not has_already_been_visited(currently_over) and is_neighbouring_node(currently_over))):
		self.currently_over = currently_over

func is_neighbouring_node(currently_over: PanelEle) -> bool:
	var curr_pos: Vector2 = currently_over.position
	var prev_pos: Vector2 = line.get_point_position(line.get_point_count() - 2)
	if curr_pos.x == prev_pos.x:
		return is_equal_approx(abs(curr_pos.y - prev_pos.y), PANEL_ELE_CONVERTER.NEIGH_DIST)
	elif curr_pos.y == prev_pos.y:
		return is_equal_approx(abs(curr_pos.x - prev_pos.x), PANEL_ELE_CONVERTER.NEIGH_DIST)
	else:
		return false
	
func _neigh_has_been_visited(intersection_pos: Vector2, dir: Vector2) -> bool:
	return _has_already_been_visited(intersection_pos + dir * PANEL_ELE_CONVERTER.NEIGH_DIST)

func _can_move_mouse_to(intersection: PanelEle, dir: Vector2) -> bool:
	var mouse_over_coord = intersection.board_coord + dir
	return CURRENT_PANEL.panel_dict.has(mouse_over_coord) and CURRENT_PANEL.panel_dict[mouse_over_coord] == PANEL_ELEMENTS.Ele.PIPE

func _should_turn(intersection_pos: Vector2, dir: Vector2) -> bool:
	return intersection_pos != _last_drawing_origin() and (line.get_point_position(line.get_point_count() - 2) - line.get_point_position(line.get_point_count() - 1)).normalized() != dir

func _should_change_dir(intersection_pos: Vector2, dir: Vector2) -> bool:
	return intersection_pos == _last_drawing_origin() and (line.get_point_position(line.get_point_count() - 3) - line.get_point_position(line.get_point_count() - 2)).normalized() != dir

func _should_go_back(intersection_pos: Vector2, dir: Vector2) -> bool:
	return intersection_pos == _last_drawing_origin() and (line.get_point_position(line.get_point_count() - 3) - line.get_point_position(line.get_point_count() - 2)).normalized() == dir

func curr_over_exited(curr_over: PanelEle):
	# This is the case where you've entered something you shouldn't
	if not is_drawing or self.currently_over != curr_over:
		return
	var mouse_move_dir: Vector2 = currently_over.get_drawing_dir()
	if not _can_move_mouse_to(curr_over, mouse_move_dir):
		return
	if _should_turn(currently_over.position, mouse_move_dir):
		_turn(currently_over.position, mouse_move_dir)
	elif _should_change_dir(currently_over.position, mouse_move_dir):
		_change_dir(mouse_move_dir)
	else:
		self.drawing_dir = -mouse_move_dir
		if _should_go_back(currently_over.position, mouse_move_dir):
			_go_back(currently_over.position)
	currently_over = null

# TODO: Implement
func check_for_finish(finish: PanelFinish):
	pass
