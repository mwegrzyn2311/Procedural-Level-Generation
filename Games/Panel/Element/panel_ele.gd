extends StaticBody2D

class_name PanelEle

@onready var collision: CollisionShape2D = $Collision
@onready var texture: TextureRect = $Texture

var board: PanelBoard
var board_coord: Vector2

func initialize(board: PanelBoard, board_coord: Vector2, coords: Vector2, is_vertical: bool = false):
	self.board = board
	self.board_coord = board_coord
	set_coords(coords)
	self.apply_scale(Vector2(PANEL_ELEMENTS.ELE_SCALE, PANEL_ELEMENTS.ELE_SCALE))

func set_coords(coords: Vector2):
	self.position = coords

# TODO: Investigate if global_position should be used instead
func is_inside() -> bool:
	return abs(get_global_mouse_position() - self.global_position) <= Vector2(PANEL_ELEMENTS.ELE_SIZE, PANEL_ELEMENTS.ELE_SIZE)

func get_drawing_dir() -> Vector2:
	return Dir2.closest_dir(get_global_mouse_position() - self.global_position)
