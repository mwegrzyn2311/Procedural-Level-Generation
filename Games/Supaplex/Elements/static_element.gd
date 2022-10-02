extends StaticBody2D
class_name StaticElement

func set_coords(coordinates: Vector2):
	self.position = (coordinates + Vector2(1, 1)) * CONSTANTS.TILE_SIZE
