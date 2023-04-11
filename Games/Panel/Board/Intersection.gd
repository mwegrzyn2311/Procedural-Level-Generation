extends StaticBody2D

# TODO: Should be in _init() when those will be created programatically
@onready var board: Board = $"../../"
var has_been_passed: bool = false


func _on_mouse_entered():
	if board.is_drawing:
		if self.has_been_passed:
			pass
		self.has_been_passed = true
		board.turn(self.position)
