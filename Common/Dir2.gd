extends Node

func closest_dir(dir: Vector2) -> Vector2:
	if abs(dir.x) > abs(dir.y):
		return Vector2.RIGHT if dir.x > 0 else Vector2.LEFT
	else:
		return Vector2.UP if dir.y < 0 else Vector2.DOWN

func is_dir(vec: Vector2) -> bool:
	return vec == Vector2.RIGHT or vec == Vector2.DOWN or vec == Vector2.LEFT or vec == Vector2.UP

func is_vertical(vec: Vector2) -> bool:
	return vec.x == 0
	
func is_horizontal(vec: Vector2) -> bool:
	return vec.y == 0

# WARNING: THIS IMPLEMENTATION HAS NOT BEEN TESTED
func right_or_left(a: Vector2, b: Vector2, c: Vector2) -> Vector2:
	var vec1: Vector2 = b - a
	var vec2: Vector2 = c - b
	return Vector2(vec1.x * vec2.y - vec1.y * vec2.x, 0)

func go_right_or_left(a: Vector2, b: Vector2, dir: Vector2) -> Vector2:
	assert(dir == Vector2.RIGHT or dir == Vector2.LEFT, "Dir2#go_right_or_left should only get RIGHT or LEFT as dir")
	var last_vec: Vector2 = b - a
	return Vector2(- last_vec.y, last_vec.x) * dir.x
