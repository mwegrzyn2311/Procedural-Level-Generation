extends Node

var level_generator: SupaplexTemplateLevelGenerator

func _ready():
	self.level_generator = SupaplexTemplateLevelGenerator.new(CURRENT_LEVEL_INFO.width, CURRENT_LEVEL_INFO.height, SUPAPLEX_TEMPLATES.TEMPLATES_6)
	

func generate_level(width: int, height: int, difficulty: int) -> Array:
	return LEVEL_CONVERTER.vec_string_dict_to_tile_arr(level_generator.generate_level())
	# Hardcoded array for testing purposes
#	return [
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.WALL, Vector2(8, 4)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.WALL, Vector2(7, 6)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.WALL, Vector2(7, 4)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.WALL, Vector2(8, 2)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.WALL, Vector2(6, 2)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.WALL, Vector2(8, 6)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.WALL, Vector2(9, 6)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.WALL, Vector2(10, 4)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.WALL, Vector2(10, 6)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.WALL, Vector2(10, 2)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.WALL, Vector2(10, 5)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.WALL, Vector2(10, 3)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.WALL, Vector2(10, 1)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.GRASS, Vector2(4, 5)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.GRASS, Vector2(3, 4)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.GRASS, Vector2(5, 5)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.BOULDER, Vector2(3, 3)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.BOULDER, Vector2(4, 3)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.BOULDER, Vector2(7, 2)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.BOULDER, Vector2(2, 6)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.BOULDER, Vector2(5, 10)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.BOULDER, Vector2(6, 9)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.BOULDER, Vector2(6, 8)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.BOULDER, Vector2(5, 8)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.POINT, Vector2(7, 3)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.POINT, Vector2(4, 6)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.PLAYER, Vector2(8, 8)),
#		TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.EXIT, Vector2(7, 8)),
#]
