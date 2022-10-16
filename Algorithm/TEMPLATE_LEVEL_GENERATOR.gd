extends Node

# This class is responsile for generating levels from 3x3 tile templates

const rock_chance_mult: float = 0.3

func generate_level(width: int, height: int, level_templates: LevelTemplates) -> Dictionary:
	var templates: Array = level_templates.templates
	var t_width: int = level_templates.template_width
	var t_height: int = level_templates.template_height
	
	var tiles_vert: int = height/t_height
	var tiles_horiz: int = width/t_width
	
	var templates_count = templates.size()
	var res: Dictionary = {}
	for j in range(tiles_vert):
		for i in range(tiles_horiz):
			# TODO: Add rotation and flip
			var template_index = RNG_UTIL.RNG.randi_range(0, templates_count - 1)
			var template = templates[template_index]
			for t_j in range(t_height):
				for t_i in range(t_width):
					res[Vector2(i * t_width + t_i, j * t_height + t_j)] = template[t_j][t_i]
	
	# Randomly change grass into rocks
	# Chance to turn grass into rocks should depent on:
	# a) Height between roof and ground because rocks on the bottom are less interesting
	# b) 
	# c) TODO:Should not block passages too often, so number of wall neighbouring on diagonals should also be counted
	# d) ???
	var rock_chances_mult: Dictionary = rock_chances_mult(width, height, res)
	
	for pos in res:
		if res[pos] == "grass":
			# TODO: Extract chances to constants
			var random_roll = RNG_UTIL.RNG.randf()
			if random_roll < rock_chances_mult[pos] * rock_chance_mult:
				res[pos] = "boulder"
			elif random_roll < 0.4:
				res[pos] = "point" 
	# TODO: Consider randomly changing grass randomly to empty if rock is not above it. Chance should be higher when neighbours are rocks but not if it's below a rock
	
	# TODO: Consider better way to place the player
	# Randomly change random element into player
	var player_i = RNG_UTIL.RNG.randi_range(0, tiles_vert - 1)
	var player_j = RNG_UTIL.RNG.randi_range(0, tiles_horiz - 1)
	res[Vector2(player_i, player_j)] = "player"
	
	return res

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
	const DEPTH_MODIF: float = 0.0
	var depth_max: float = get_passage_width_in_dir(map, start, dir)
	var depth: float = depth_max
	while depth > 0:
		chances_mult[start + Vector2(0, depth_max - depth)] = (depth + DEPTH_MODIF) / (depth_max + DEPTH_MODIF) 
		depth -= 1.0

func analyze_row_chances(chances_mult: Dictionary, map: Dictionary, start: Vector2) -> void:
	const dir: Vector2 = Vector2(1, 0)
	# Starting value of depth can be increased to decrease impact, especially for lower widths
	const WIDTH_MODIF: float = 1.0
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
	
