extends Node

func ele_instance(packed_scene: PackedScene, coords: Vector2):
	var ele = packed_scene.instantiate()
	ele.set_coords(coords)
	return ele
