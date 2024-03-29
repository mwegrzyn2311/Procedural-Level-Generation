extends TemplateLevelGenerator
class_name SupaplexTemplateLevelGeneratorV1

# This class is responsile for generating levels from 3x3 tile templates

const ROCK_CHANCE_MULT: float = 0.2
const EMPTY_CHANCE_MULT: float = 0.6
const DEPTH_MODIF: float = 0.0
const WIDTH_MODIF: float = 1.0
var MAKE_EMPTY_NEIGH_TO_CHANCE: Dictionary = {
	TILE_ELEMENTS.Ele.GRASS: 0.2,
	TILE_ELEMENTS.Ele.BOULDER: 0.5
}

func _init(width: int, height: int, level_templates: LevelTemplates):
	super(width, height, level_templates)

# TODO: I think that with some templates it's possible to get an occurence that no template would fit which leads to inifite loop
# TODO: It'd also be good to not pick the same template with the same rotation twice but with so many choices it might consume some memory and maybe even time...
func generate_level() -> Dictionary:
	var res: Dictionary = {}
	var i = 0
	while res.is_empty() or not SUPAPLEX_UTILS.is_one_open_region(res):
		res = super.generate_level()
		i += 1
	print("generated open region after " + str(i) + " tries")
	# Randomly change grass into rocks/ points
	# Chance to turn grass into rocks should depend on:
	# a) Height between roof and ground because rocks on the bottom are less interesting
	# b) In order to not block thin vertical passages, chance should be decreased based on width of such passage
	# c) The above should apply to horizontal passages as well
	# d) TODO:Should not block passages too often, so number of wall neighbouring on diagonals?
	# e) ???
	res = place_rocks(res)
	res = place_empty(res)
	res = place_player(res)
	return res
	
func place_exit(res: Dictionary) -> Dictionary:
	var rand_grass_pos: Vector2 =  RNG_UTIL.choice(res.keys().filter(func(pos): res[pos] == TILE_ELEMENTS.Ele.GRASS))
	res[rand_grass_pos] = TILE_ELEMENTS.Ele.EXIT
	return res
	
func place_rocks(res: Dictionary) -> Dictionary:
	var rock_chances_mult: Dictionary = rock_chances_mult(width, height, res)
	for pos in res:
		if res[pos] == TILE_ELEMENTS.Ele.GRASS:
			# TODO: Extract chances to constants
			var random_roll = RNG_UTIL.RNG.randf()
			if random_roll < rock_chances_mult[pos] * ROCK_CHANCE_MULT:
				res[pos] = TILE_ELEMENTS.Ele.BOULDER
			# TODO: Much better way for placing points
			elif random_roll < 0.4:
				res[pos] = TILE_ELEMENTS.Ele.POINT
	return res

func place_empty(res: Dictionary) -> Dictionary:
	# TODO: Consider randomly changing grass randomly to empty if rock is not above it. Chance should be higher when neighbours are rocks but not if it's below a rock
	for pos in res:
		if res[pos] == TILE_ELEMENTS.Ele.GRASS:
			if RNG_UTIL.RNG.randf() < chance_make_empty(res, pos):
				res[pos] = TILE_ELEMENTS.Ele.EMPTY
				
	return res

func place_player(res: Dictionary) -> Dictionary:
		# TODO: Consider better way to place the player
	# Randomly change random element into player
	var player_pos: Vector2 = RNG_UTIL.rand_vec2(width, height)
	while res[player_pos] != TILE_ELEMENTS.Ele.GRASS:
		# reroll
		player_pos = RNG_UTIL.rand_vec2(width, height)
	res[player_pos] = TILE_ELEMENTS.Ele.PLAYER
	
	return res

func chance_make_empty(map: Dictionary, pos: Vector2) -> float:
	var chance: float = 0.0
	var above: Vector2 = pos + Vector2(0, -1)
	if map.has(above) and map[above] == TILE_ELEMENTS.Ele.BOULDER:
		return chance
	# Vertical Neighbours affect this chance
	chance += COLLECTION_UTIL.dict_get_or_default(MAKE_EMPTY_NEIGH_TO_CHANCE, COLLECTION_UTIL.dict_get_or_default(map, pos + Vector2(1, 0), TILE_ELEMENTS.Ele.EMPTY), 0.0)
	chance += COLLECTION_UTIL.dict_get_or_default(MAKE_EMPTY_NEIGH_TO_CHANCE, COLLECTION_UTIL.dict_get_or_default(map, pos + Vector2(-1, 0), TILE_ELEMENTS.Ele.EMPTY), 0.0)
	return chance

func rock_chances_mult(width: int, height: int, map: Dictionary) -> Dictionary:
	var vert_chances_mult: Dictionary = {}
	var horiz_chances_mult: Dictionary = {}
	for j in range(height):
		for i in range(width):
			var curr = Vector2(i, j)
			if map[curr] == TILE_ELEMENTS.Ele.GRASS:
				if !vert_chances_mult.has(curr):
					analyze_column_chances(vert_chances_mult, map, curr)
				if !horiz_chances_mult.has(curr):
					analyze_row_chances(horiz_chances_mult, map, curr)
	
	var chances_mult: Dictionary = {}
	for j in range(height):
		for i in range(width):
			var curr = Vector2(i, j)
			chances_mult[Vector2(i, j)] = COLLECTION_UTIL.dict_get_or_default(vert_chances_mult, curr, 1.0) * COLLECTION_UTIL.dict_get_or_default(horiz_chances_mult, curr, 1.0)
	return chances_mult

func analyze_column_chances(chances_mult: Dictionary, map: Dictionary, start: Vector2) -> void:
	const dir: Vector2 = Vector2(0, 1)
	# Starting value of depth can be increased to decrease impact for higher depths
	var depth_max: float = get_passage_width_in_dir(map, start, dir)
	var depth: float = depth_max
	while depth > 0:
		chances_mult[start + Vector2(0, depth_max - depth)] = ((depth + DEPTH_MODIF) / (depth_max + DEPTH_MODIF)) * (depth_max / (depth_max + WIDTH_MODIF))
		depth -= 1.0

func analyze_row_chances(chances_mult: Dictionary, map: Dictionary, start: Vector2) -> void:
	const dir: Vector2 = Vector2(1, 0)
	# Starting value of depth can be increased to decrease impact, especially for lower widths
	var width_max: float = get_passage_width_in_dir(map, start, dir)
	for i in range(width_max):
		chances_mult[start + Vector2(i, 0)] = width_max / (width_max + WIDTH_MODIF)

func get_passage_width_in_dir(map: Dictionary, start: Vector2, dir: Vector2) -> int:
	var depth: int = 0
	var curr = Vector2(start)
	while map[curr] != TILE_ELEMENTS.Ele.GRASS:
		curr += dir
		depth += 1
	return depth
