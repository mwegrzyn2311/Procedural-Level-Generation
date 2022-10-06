extends Node

var width: int = 20
var height: int = 20
var difficulty: int = 5
var points: int = 0
var collected_points: int = 0

var level_map: Array = []

func set_width(width: int):
	self.width = width
	
func set_height(height: int):
	self.height = height
	
func generate_map():
	self.level_map = SUPAPLEX_LEVEL_GENERATOR.generate_level(self.width, self.height, self.difficulty)
	self.points = number_of_points_in_map()
	print("hmm")

func number_of_points_in_map() -> int:
	return self.level_map.filter(is_game_point).map(get_point_value).reduce(sum, 0)

func is_game_point(ele: Node2D) -> bool:
	return ele.is_in_group("game_point")

func get_point_value(ele: Node2D) -> bool:
	return ele.VALUE

# TODO: Extract to some utils	
func sum(accum, val) -> int:
	return accum + val

func inc_collected_points(quantity: int):
	self.collected_points += quantity

# TODO: Move to UI once it's created
func _ready():
	if level_map.is_empty():
		self.generate_map()
