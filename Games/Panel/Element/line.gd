extends Line2D

class_name Line

var sim_line: Array[Vector2]

# @Override
func _init():
	super._init()
	self.sim_line = []

func clear_points_custom():
	self.clear_points()
	self.sim_line.clear()

func add_point_custom(line_pos: Vector2, coord: Vector2):
	self.add_point(line_pos)
	self.sim_line.append(coord)

func add_intersection(intersection_pos: Vector2, mouse_pos: Vector2, intersection_coord: Vector2):
	self.set_point_position(self.get_point_count() - 1, intersection_pos)
	self.add_point(mouse_pos)
	self.sim_line.append(intersection_coord)

func remove_last_intersection():
	self.remove_point_custom(self.get_point_count() - 2)
	self.sim_line.pop_back()

func remove_point_custom(idx: int):
	self.remove_point(idx)
	self.sim_line.remove_at(idx)

func add_coord_tmp(coord: Vector2):
	self.sim_line.append(coord)

func remove_coord_tmp():
	self.sim_line.pop_back()
