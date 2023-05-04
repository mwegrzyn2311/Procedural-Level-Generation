extends Node

func closest_dir(dir: Vector2) -> Vector2:
	if abs(dir.x) > abs(dir.y):
		return Vector2.RIGHT if dir.x > 0 else Vector2.LEFT
	else:
		return Vector2.UP if dir.y < 0 else Vector2.DOWN

func is_dir(vec: Vector2) -> bool:
	return vec == Vector2.RIGHT or vec == Vector2.DOWN or vec == Vector2.LEFT or vec == Vector2.UP
