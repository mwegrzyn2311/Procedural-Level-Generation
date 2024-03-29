extends Node

var width: int = 12
var height: int = 12
var difficulty: int = 5
var total_points: int = 2
var collected_points: int = 0

var level_map: Array = []
var map_backup: Dictionary = {}

var level_generator: LevelGenerator = null

func set_width(width: int):
	self.width = width
	
func set_height(height: int):
	self.height = height
	
func apply():
	if MENU_INFO.selectedAlgo == CONSTANTS.SupportedAlgos.TEMPLATE_BASED:
		level_generator = SupaplexTemplateLevelGenerator.new(width, height, SUPAPLEX_TEMPLATES.TEMPLATES_6)
	elif MENU_INFO.selectedAlgo == CONSTANTS.SupportedAlgos.MONTE_CARLO:
		level_generator = SupaplexMCTSLevelGenerator.new(width, height)

func generate_map():
	self.map_backup = level_generator.generate_level()
	self.level_map = LEVEL_CONVERTER.vec_string_dict_to_tile_arr(map_backup)
	self.total_points = number_of_points_in_map()

func regenerate_map():
	self.level_map = LEVEL_CONVERTER.vec_string_dict_to_tile_arr(map_backup)
	self.total_points = number_of_points_in_map()

func number_of_points_in_map() -> int:
	return self.level_map.filter(is_game_point).map(get_point_value).reduce(sum, 0)

func is_game_point(ele: Node2D) -> bool:
	return ele.is_in_group("game_point")

func get_point_value(ele: Node2D) -> int:
	return ele.get_value()

# TODO: Extract to some utils	
func sum(accum, val) -> int:
	return accum + val

func inc_collected_points(quantity: int):
	self.collected_points += quantity

func win_condition_fulfilled() -> bool:
	return  self.collected_points == self.total_points

