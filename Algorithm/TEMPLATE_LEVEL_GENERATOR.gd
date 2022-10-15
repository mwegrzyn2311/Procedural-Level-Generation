extends Node

# This class is responsile for generating levels from 3x3 tile templates

func generate_level(width: int, height: int, templates: Array) -> Dictionary:
	var templates_count = templates.size()
	var res: Dictionary = {}
	for j in range(height/3):
		for i in range(width/3):
			# TODO: Add rotation and flip
			var template_index = RNG_UTIL.RNG.randi_range(0, templates_count - 1)
			var template = templates[template_index]
			for t_j in range(3):
				for t_i in range(3):
					res[Vector2(i * 3 + t_i, j * 3 + t_j)] = template[t_j][t_i]
	
	# Randomly change random element into player
	var player_i = RNG_UTIL.RNG.randi_range(0, (width/3) - 1)
	var player_j = RNG_UTIL.RNG.randi_range(0, (height/3) - 1)
	res[Vector2(player_i, player_j)] = "player"
	
	# Randomly change grass into rocks
	for pos in res:
		if res[pos] == "grass":
			# TODO: Extract chances to constants
			var random_roll = RNG_UTIL.RNG.randf()
			if random_roll < 0.3:
				res[pos] = "boulder"
			elif random_roll < 0.33:
				res[pos] = "point"
	
	return res
