extends Node

var width: int = 20
var height: int = 20
var difficulty: int = 5

var level_map: Array = []

func set_width(width: int):
	self.width = width
	
func set_height(height: int):
	self.height = height
	
func generate_map():
	self.level_map = SUPAPLEX_LEVEL_GENERATOR.generate_level(self.width, self.height, self.difficulty)

# TODO: Move to UI
func _ready():
	if level_map.is_empty():
		self.generate_map()
