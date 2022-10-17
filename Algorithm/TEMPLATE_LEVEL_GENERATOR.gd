extends Node

# This class is responsile for generating levels from 3x3 tile templates

const ROCK_CHANCE_MULT: float = 0.3
const EMPTY_CHANCE_MULT: float = 0.4
const DEPTH_MODIF: float = 0.0
const WIDTH_MODIF: float = 1.0
const MAKE_EMPTY_NEIGH_TO_CHANCE: Dictionary = {
	"grass": 0.1,
	"rock": 0.5
}

func generate_level(width: int, height: int, level_templates: LevelTemplates) -> Dictionary:
	var templates: Array = level_templates.templates
	var t_width: int = level_templates.template_width
	var t_height: int = level_templates.template_height
	
	var tile_vectors: Array = self.tile_vectors2(t_width, t_height)
	var rotation_vectors: Array = self.rotation_tile_vectors(t_width, t_height)
	assert(tile_vectors.size() == rotation_vectors[0].size())
	
	var tiles_vert: int = height/t_height
	var tiles_horiz: int = width/t_width
	
	var templates_count = templates.size()
	var res: Dictionary = {}
	# Start off by building levels out of random templates
	for j in range(tiles_vert):
		for i in range(tiles_horiz):
			# TODO: Add rotation and flip
			var template_index: int = RNG_UTIL.RNG.randi_range(0, templates_count - 1)
			var rotation: Array = RNG_UTIL.choice(rotation_vectors)
			var template = templates[template_index]
			for tile_i in range(tile_vectors.size()):
				res[Vector2(i * t_width, j * t_height) + tile_vectors[tile_i]] = template[rotation[tile_i]]
			for tile_vec in tile_vectors:
				res[Vector2(i * t_width, j * t_height) + tile_vec] = template[tile_vec]
	
	# Randomly change grass into rocks/ points
	# Chance to turn grass into rocks should depend on:
	# a) Height between roof and ground because rocks on the bottom are less interesting
	# b) In order to not block thin vertical passages, chance should be decreased based on width of such passage
	# c) The above should apply to horizontal passages as well
	# d) TODO:Should not block passages too often, so number of wall neighbouring on diagonals 
	# e) ???
	var rock_chances_mult: Dictionary = rock_chances_mult(width, height, res)
	for pos in res:
		if res[pos] == "grass":
			# TODO: Extract chances to constants
			var random_roll = RNG_UTIL.RNG.randf()
			if random_roll < rock_chances_mult[pos] * ROCK_CHANCE_MULT:
				res[pos] = "boulder"
			# TODO: Much better way for placing points
			elif random_roll < 0.4:
				res[pos] = "point" 
	# TODO: Consider randomly changing grass randomly to empty if rock is not above it. Chance should be higher when neighbours are rocks but not if it's below a rock
	for pos in res:
		if res[pos] == "grass":
			if RNG_UTIL.RNG.randf() < chance_make_empty(res, pos):
				res[pos] = "empty"
	
	# TODO: Consider better way to place the player
	# Randomly change random element into player
	res[RNG_UTIL.rand_vec2(width, height)] = "player"
	
	return res

func chance_make_empty(map: Dictionary, pos: Vector2) -> float:
	var chance: float = 0.0
	var above: Vector2 = pos + Vector2(0, 1)
	if map.has(above) and map[above] == "rock":
		return chance
	# Vertical Neighbours affect this chance
	chance += COLLECTION_UTIL.dict_get_or_default(MAKE_EMPTY_NEIGH_TO_CHANCE, COLLECTION_UTIL.dict_get_or_default(map, pos + Vector2(1, 0), "null"), 0.0)
	chance += COLLECTION_UTIL.dict_get_or_default(MAKE_EMPTY_NEIGH_TO_CHANCE, COLLECTION_UTIL.dict_get_or_default(map, pos + Vector2(-1, 0), "null"), 0.0)
	return chance

func rock_chances_mult(width: int, height: int, map: Dictionary) -> Dictionary:
	var vert_chances_mult: Dictionary = {}
	var horiz_chances_mult: Dictionary = {}
	for i in range(height):
		for j in range(width):
			var curr = Vector2(i, j)
			if map[curr] == "grass":
				if !vert_chances_mult.has(curr):
					analyze_column_chances(vert_chances_mult, map, curr)
				if !horiz_chances_mult.has(curr):
					analyze_row_chances(horiz_chances_mult, map, curr)
	
	var chances_mult: Dictionary = {}
	for i in range(height):
		for j in range(width):
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
	while map[curr] != "grass":
		curr += dir
		depth += 1
	return depth

func tile_vectors2(width: int, height: int) -> Array:
	var res = []
	for j in range(height):
		for i in range(width):
			res.append(Vector2(i, j))
	return res

# TODO: Switch from hardcoded for 3x3 to universally calculated
# TODO: Consider extracting
func rotation_tile_vectors(width: int, height: int) -> Array:
	# Order here has crucial importance!
	return [
		# 0 degree
		[
			Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), 
			Vector2(0, 1), Vector2(1, 1), Vector2(2, 1),
			Vector2(0, 2), Vector2(1, 2), Vector2(2, 2)
		],
		# 90 degree
		[
			Vector2(0, 2), Vector2(0, 1), Vector2(0, 0), 
			Vector2(1, 2), Vector2(1, 1), Vector2(1, 0),
			Vector2(2, 2), Vector2(2, 1), Vector2(2, 0)
		],
		# 180 degree
		[
			Vector2(2, 2), Vector2(1, 2), Vector2(0, 2), 
			Vector2(2, 1), Vector2(1, 1), Vector2(1, 0),
			Vector2(2, 0), Vector2(1, 0), Vector2(0, 0)
		],
		# 270 degree
		[
			Vector2(2, 0), Vector2(2, 1), Vector2(2, 2), 
			Vector2(1, 0), Vector2(1, 1), Vector2(1, 2),
			Vector2(0, 0), Vector2(0, 1), Vector2(0, 2)
		],
		# 0 degree + horizontal tilt
		[
			Vector2(2, 0), Vector2(1, 0), Vector2(0, 0), 
			Vector2(2, 1), Vector2(1, 1), Vector2(0, 1),
			Vector2(2, 2), Vector2(1, 2), Vector2(0, 2)
		],
		# 90 degree + horizontal tilt
		[
			Vector2(0, 0), Vector2(0, 1), Vector2(0, 2), 
			Vector2(1, 0), Vector2(1, 1), Vector2(1, 2),
			Vector2(2, 0), Vector2(2, 1), Vector2(2, 2)
		],
		# 180 degree + horizontal tilt
		[
			Vector2(0, 2), Vector2(1, 2), Vector2(2, 2), 
			Vector2(0, 1), Vector2(1, 1), Vector2(2, 1),
			Vector2(0, 0), Vector2(1, 0), Vector2(2, 0)
		],
		# 270 degree + horizontal tilt
		[
			Vector2(2, 2), Vector2(2, 1), Vector2(2, 0), 
			Vector2(1, 2), Vector2(1, 1), Vector2(1, 0),
			Vector2(0, 2), Vector2(0, 1), Vector2(0, 0)
		],
	]
