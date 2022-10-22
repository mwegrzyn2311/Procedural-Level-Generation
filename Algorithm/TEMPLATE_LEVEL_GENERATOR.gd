extends Node
class_name TemplateLevelGenerator

# This class is responsile for generating levels from 3x3 tile templates

const ROCK_CHANCE_MULT: float = 0.3
const EMPTY_CHANCE_MULT: float = 0.4
const DEPTH_MODIF: float = 0.0
const WIDTH_MODIF: float = 1.0
const MAKE_EMPTY_NEIGH_TO_CHANCE: Dictionary = {
	"grass": 0.1,
	"rock": 0.5
}

var width: int = 1
var height: int = 1
var t_width: int = 1
var t_height: int = 1
var level_templates: LevelTemplates
var tile_vectors: Array = []
var rotation_vectors: Array = []
var neighbour_constraint_vectors: Array = []
var constraint_rotation_vectors: Array = []

func _init(width: int, height: int, level_templates: LevelTemplates):
	self.width = width
	self.height = height
	self.t_width = level_templates.template_width
	self.t_height = level_templates.template_height
	self.level_templates = level_templates
	self.tile_vectors = self.tile_vectors2(t_width, t_height)
	self.rotation_vectors = self.rotation_tile_vectors(t_width, t_height)
	self.neighbour_constraint_vectors = self.neighbour_constraint_vectors2(t_width, t_height)
	self.constraint_rotation_vectors = self.constraint_rotation_vectors2(t_width, t_height)

func generate_level() -> Dictionary:
	var templates: Array = level_templates.templates
	

	assert(tile_vectors.size() == rotation_vectors[0].size())
	
	var tiles_vert: int = self.height/t_height
	var tiles_horiz: int = self.width/t_width
	
	var templates_count = templates.size()
	var rotations_count = self.rotation_vectors.size()
	var res: Dictionary = {}
	# Start off by building levels out of random templates
	for j in range(tiles_vert):
		for i in range(tiles_horiz):
			var template_chosen: bool = false
			while !template_chosen:
				var template_index: int = RNG_UTIL.RNG.randi_range(0, templates_count - 1)
				var rotation_index: int = RNG_UTIL.RNG.randi_range(0, rotations_count - 1)
				var rotation: Array = self.rotation_vectors[rotation_index]
				var neighbour_constraint_rotation = self.constraint_rotation_vectors[rotation_index]
				var template: Dictionary = templates[template_index]
				var base: Vector2 = Vector2(i * t_width, j * t_height)
				if template_fits(base, res, template, rotation, neighbour_constraint_rotation):
					template_chosen = true
					# Place template tiles
					for tile_i in range(self.tile_vectors.size()):
						res[base + self.tile_vectors[tile_i]] = template[rotation[tile_i]]
					# Place template tiles that ensure good template connections
					for tile_i in range(self.neighbour_constraint_vectors.size()):
						if template.has(neighbour_constraint_rotation[tile_i]):
							res[base + self.neighbour_constraint_vectors[tile_i]] = template[neighbour_constraint_rotation[tile_i]]
	# Randomly change grass into rocks/ points
	# Chance to turn grass into rocks should depend on:
	# a) Height between roof and ground because rocks on the bottom are less interesting
	# b) In order to not block thin vertical passages, chance should be decreased based on width of such passage
	# c) The above should apply to horizontal passages as well
	# d) TODO:Should not block passages too often, so number of wall neighbouring on diagonals?
	# e) ???
	# TODO: Extract?
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
	var player_pos: Vector2 = RNG_UTIL.rand_vec2(width, height)
	while res[player_pos] != "grass":
		# reroll
		player_pos = RNG_UTIL.rand_vec2(width, height)
	res[player_pos] = "player"
	
	return res
	
func template_fits(base: Vector2, map: Dictionary, template: Dictionary, rotation: Array, neighbour_constraint_rotation: Array) -> bool:
	# Start by checking if there would appear a different type of tile on existing tile
	for tile_i in range(self.tile_vectors.size()):
		var pos: Vector2 = base + self.tile_vectors[tile_i]
		if map.has(pos) and map[pos] != template[rotation[tile_i]]:
			return false
	# Then check if neighbours don't overlap
	for tile_i in range(self.neighbour_constraint_vectors.size()):
		var pos: Vector2 = base + self.neighbour_constraint_vectors[tile_i]
		if template.has(neighbour_constraint_rotation[tile_i]) and (!is_in_map(pos) or (map.has(pos) and map[pos] != template[neighbour_constraint_rotation[tile_i]])):
			return false
	return true
			
func is_in_map(pos: Vector2) -> bool:
	return pos.x >= 0 and pos.x < self.width and pos.y >= 0 and pos.y < self.height

func chance_make_empty(map: Dictionary, pos: Vector2) -> float:
	var chance: float = 0.0
	var above: Vector2 = pos + Vector2(0, -1)
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
	
# TODO: Consider diagonals
func neighbour_constraint_vectors2(width: int, height: int) -> Array:
	var res = []
	for i in range(width):
		res.append(Vector2(i, -1))
	for j in range(height):
		res.append(Vector2(3, j))
	for i in range(width):
		res.append(Vector2(i, 3))
	for j in range(height):
		res.append(Vector2(-1, j))
	return res
	
func constraint_rotation_vectors2(width: int, height: int) -> Array:
	assert(width == height, "templates with width != height not supported yet")
	var res = []
	var len = self.neighbour_constraint_vectors.size()
	res.append(Array(self.neighbour_constraint_vectors))
	for i in range(1, 4):
		res.append(self.neighbour_constraint_vectors.slice(i * width, len) + self.neighbour_constraint_vectors.slice(0, i * width))
	for i in range(4):
		var arr: Array = Array(res[(i + 1) % 4])
		arr.reverse()
		res.append(arr)
	# !!! It's here to keep sync with rotation_tile_vectors(). However if implementation changes, it has to be verified that it still stays in sync
	res.reverse()
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
