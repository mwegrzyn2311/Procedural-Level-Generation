extends TemplateLevelGenerator
class_name SupaplexTemplateLevelGenerator

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
	var time_start = Time.get_unix_time_from_system()
	var time_now = Time.get_unix_time_from_system()
	var time_limit = 3.0
	while res.is_empty() or not SUPAPLEX_UTILS.is_one_open_region(res):
		res = super.generate_level()
		i += 1
	print("generated open region after " + str(i) + " tries")

	# Move randomly - TODO: Moves or sequences?
	var pathLen: int = -1
	var minPathLen: int = int(sqrt(width * height * 2))
	var best_score: int = -1
	var best_res: Dictionary
	var curr_pos: Vector2
	while true:
		var curr_res = res.duplicate(true)
		var tmp_map = curr_res.duplicate(true)
		var falling_eles_at: Array[Vector2] = []
		time_now = Time.get_unix_time_from_system()
		var unique_visited_fields: Array[Vector2] = []
		var initial_player_pos: Vector2 = RNG_UTIL.rand_vec2(width, height)
		curr_pos = initial_player_pos
		var has_pushed: bool = false
		for action_i in range(width * height * 2):
			var action_chance: float = RNG_UTIL.RNG.randf()
			if action_chance < 0.5:
				# Move
				var possible_moves = CONSTANTS.UNIT_VECTORS\
					.map(func(unit_vec: Vector2) -> Vector2: return curr_pos + unit_vec)\
					.filter(func(dest: Vector2) -> bool: return is_in_map(dest) and not(is_in_map(dest + Vector2.UP) and (dest + Vector2.UP) in falling_eles_at) and (TILE_ELEMENTS._can_move_to(tmp_map[dest]) or ((dest + (dest - curr_pos)) in tmp_map and tmp_map[dest] == TILE_ELEMENTS.Ele.BOULDER and tmp_map[(dest + (dest - curr_pos))] == TILE_ELEMENTS.Ele.EMPTY)))
				if possible_moves.is_empty():
					break
				var new_pos = RNG_UTIL.choice(possible_moves)
				var sim_res: SUPAPLEX_UTILS.SimRes = SUPAPLEX_UTILS.simulate_one_turn(tmp_map, falling_eles_at, curr_pos, new_pos, width, height)
				if curr_pos not in unique_visited_fields:
					var ele_to_place = TILE_ELEMENTS.Ele.POINT if (action_chance < 0.175 and not((curr_pos + Vector2.DOWN) in curr_res and curr_res[(curr_pos + Vector2.DOWN)] == TILE_ELEMENTS.Ele.EMPTY)) else TILE_ELEMENTS.Ele.GRASS
					curr_res[curr_pos] = ele_to_place
					unique_visited_fields.append(curr_pos)
				if sim_res == SUPAPLEX_UTILS.SimRes.FAIL:
					break
				elif sim_res == SUPAPLEX_UTILS.SimRes.PUSH:
					has_pushed = true
				curr_pos = new_pos
			elif action_chance < 0.625:
				# Wait
				if (curr_pos + Vector2.UP) in falling_eles_at:
					continue
				var sim_res: SUPAPLEX_UTILS.SimRes = SUPAPLEX_UTILS.simulate_one_turn(tmp_map, falling_eles_at, curr_pos, curr_pos, width, height)
				if sim_res == SUPAPLEX_UTILS.SimRes.FAIL:
					break
			elif action_chance < 0.75:
				# Make random tile in proximity empty
				SUPAPLEX_UTILS.PLAYER_PROXIMITY.shuffle()
				for offset in SUPAPLEX_UTILS.PLAYER_PROXIMITY:
					var pos: Vector2 = curr_pos + offset
					var above: Vector2 = pos + Vector2.UP
					if is_in_map(pos) and pos not in unique_visited_fields and curr_res[pos] == TILE_ELEMENTS.Ele.GRASS and not (above in tmp_map and TILE_ELEMENTS.is_fallable(tmp_map[above])):
						curr_res[pos] = TILE_ELEMENTS.Ele.EMPTY
						tmp_map[pos] = TILE_ELEMENTS.Ele.EMPTY
						break
			else:
				# Try Place boulder
				SUPAPLEX_UTILS.PLAYER_PROXIMITY.shuffle()
				for offset in SUPAPLEX_UTILS.PLAYER_PROXIMITY:
					var pos: Vector2 = curr_pos + offset
					var below: Vector2 = pos + Vector2.DOWN
					if is_in_map(pos) and pos not in unique_visited_fields and curr_res[pos] == TILE_ELEMENTS.Ele.GRASS and not (below in tmp_map and tmp_map[below] == TILE_ELEMENTS.Ele.EMPTY):
						curr_res[pos] = TILE_ELEMENTS.Ele.BOULDER
						tmp_map[pos] = TILE_ELEMENTS.Ele.BOULDER
						break
		
		if unique_visited_fields.size() >= minPathLen and has_pushed:
		#if time_now - time_start < time_limit:
			curr_res[curr_pos] = TILE_ELEMENTS.Ele.EXIT
			curr_res[initial_player_pos] = TILE_ELEMENTS.Ele.PLAYER
			return curr_res
		else:
			if unique_visited_fields.size() < minPathLen:
				print("Generated too small with " + str(unique_visited_fields.size()) + " out of " + str(minPathLen))
			elif not has_pushed:
				print("Didn't push")
			else:
				print("WTF")

	return res

