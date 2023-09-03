extends Node

const POS_NOT_FOUND = Vector2(-1, -1)
@onready var ELEMENTS_TO_PLACE: Array[TILE_ELEMENTS.Ele]
@onready var PLAYER_PROXIMITY: Array[Vector2]

func _ready():
	ELEMENTS_TO_PLACE = [TILE_ELEMENTS.Ele.GRASS, TILE_ELEMENTS.Ele.GRASS, TILE_ELEMENTS.Ele.GRASS, TILE_ELEMENTS.Ele.POINT]
	for y in range(-2, 3):
		for x in range(-2, 3):
			PLAYER_PROXIMITY.append(Vector2(x, y))
	PLAYER_PROXIMITY.erase(Vector2(0,0))

# func(Dictionary[Vector2, TILE_ELEMENTS.Ele])
func is_one_open_region(level_dict: Dictionary) -> bool:
	var open_tile_pos: Vector2 = find_first_open_tile_pos(level_dict)
	if open_tile_pos == POS_NOT_FOUND:
		# If only walls, return false
		return false
	var zone: Dictionary = {}
	fill_open_zone_rec(open_tile_pos, level_dict, zone)
	for y in range(CURRENT_LEVEL_INFO.height):
		for x in range(CURRENT_LEVEL_INFO.width):
			var pos: Vector2 = Vector2(x, y)
			if pos not in zone and _is_open_tile(level_dict[pos]):
				return false
	return true

func fill_open_zone_rec(curr_pos: Vector2, level_dict: Dictionary, visited: Dictionary):
	visited[curr_pos] = true
	for unit_vec in CONSTANTS.UNIT_VECTORS:
		var new_pos: Vector2 = curr_pos + unit_vec
		if in_bounds(new_pos) and not new_pos in visited and _is_open_tile(level_dict[new_pos]):
			fill_open_zone_rec(new_pos, level_dict, visited)

func find_first_open_tile_pos(level_dict: Dictionary) -> Vector2:
	for y in range(CURRENT_LEVEL_INFO.height):
		for x in range(CURRENT_LEVEL_INFO.width):
			var pos: Vector2 = Vector2(x, y)
			if _is_open_tile(level_dict[pos]):
				return pos
	return POS_NOT_FOUND

func in_bounds(pos: Vector2) -> bool:
	return pos.x >= 0 and pos.y >= 0 and pos.x < CURRENT_LEVEL_INFO.width and pos.y < CURRENT_LEVEL_INFO.height

func _is_open_tile(ele) -> bool:
	return ele != TILE_ELEMENTS.Ele.WALL and ele != TILE_ELEMENTS.Ele.OBELISK

func simulate_gameplay(placed_elements: Dictionary, player_pos_history: Array[Vector2]) -> bool:
	var elements_now: Dictionary = placed_elements.duplicate(true)
	var next_pos: Vector2 = player_pos_history[-1]
	elements_now[next_pos] = TILE_ELEMENTS.Ele.PLAYER
	var falling_eles_at: Array[Vector2] = []
	for i in range(player_pos_history.size() - 1, -1, -1):
		var curr_pos: Vector2 = next_pos
		if i > 0:
			next_pos = player_pos_history[i - 1]
			if next_pos != curr_pos and (not elements_now.has(next_pos) or not TILE_ELEMENTS._can_move_to(elements_now[next_pos])):
				# Players tried to move to an illegal position
				return false
		var new_elements: Dictionary = {}
		var new_falling_eles_at: Array[Vector2] = []
		var empties: Array[Vector2] = []
		for pos in elements_now:
			if TILE_ELEMENTS.is_fallable(elements_now[pos]):
				var below: Vector2 = pos + Vector2.DOWN
				if curr_pos == below and falling_eles_at.has(pos):
					# Falling object kills player
					return false
				if elements_now.has(below):
					if elements_now[below] == TILE_ELEMENTS.Ele.EMPTY:
						# fall
						new_elements[pos] = TILE_ELEMENTS.Ele.EMPTY
						new_elements[below] = elements_now[pos]
						new_falling_eles_at.append(below)
					elif TILE_ELEMENTS.is_fallable(elements_now[below]) and not falling_eles_at.has(below):
						# try to slide
						var left: Vector2 = pos + Vector2.LEFT
						var bel_left: Vector2 = below + Vector2.LEFT
						var right: Vector2 = pos + Vector2.RIGHT
						var bel_right: Vector2 = below + Vector2.RIGHT
						if elements_now.has(left) and elements_now[left] == TILE_ELEMENTS.Ele.EMPTY and elements_now.has(bel_left) and elements_now[bel_left] == TILE_ELEMENTS.Ele.EMPTY:
							# slide left
							new_elements[pos] = TILE_ELEMENTS.Ele.EMPTY
							new_elements[left] = elements_now[pos]
						elif elements_now.has(right) and elements_now[right] == TILE_ELEMENTS.Ele.EMPTY and elements_now.has(bel_right) and elements_now[bel_right] == TILE_ELEMENTS.Ele.EMPTY:
							# slide right
							new_elements[pos] = TILE_ELEMENTS.Ele.EMPTY
							new_elements[right] = elements_now[pos]
					else:
						# don't move, wait patiently
						new_elements[pos] = elements_now[pos]
			elif elements_now[pos] != TILE_ELEMENTS.Ele.EMPTY:
				# just copy over Those elements will neither fall nor be replaced with a falling object
				new_elements[pos] = elements_now[pos]
				
		for empty_pos in elements_now.keys().filter(func(pos): elements_now[pos] == TILE_ELEMENTS.Ele.EMPTY):
			if not new_elements.has(empty_pos):
				new_elements[empty_pos] = TILE_ELEMENTS.Ele.EMPTY
		
		if next_pos != curr_pos:
			new_elements[next_pos] = TILE_ELEMENTS.Ele.PLAYER
			new_elements[curr_pos] = TILE_ELEMENTS.Ele.EMPTY
		falling_eles_at = new_falling_eles_at
		elements_now = new_elements
	return true

#func _check_for_falling(map: Dictionary, moved_from: Vector2, falling_eles_at: Array[Vector2]):
#	# Ele above should start falling
#	var above: Vector2 = moved_from + Vector2.UP
#	if above in map and TILE_ELEMENTS.is_fallable(map[above]):
#		falling_eles_at.append(above)
#		return
#	# Vectors
#	var above_above: Vector2 = above + Vector2.UP
#	var above_right: Vector2 = above + Vector2.RIGHT
#	var above_above_right: Vector2 = above_above + Vector2.RIGHT
#	var above_left: Vector2 = above + Vector2.LEFT
#	var above_above_left: Vector2 = above_above + Vector2.LEFT
#	# Ele right above should start sliding left
#	if above_above_right in map and TILE_ELEMENTS.is_fallale(map[above_above_right])\
#		and above_right in map and not above_right in falling_eles_at and TILE_ELEMENT.is_fallable(map[above_right])\
#		and map[above_above] == TILE_ELEMENTS.Ele.EMPTY and map[above] == TILE_ELEMENTS.Ele.EMPTY\
#		and not (above_above_left in falling_eles_at and TILE_ELEMENTS.is_fallable()):
#		falling_eles_at.append(above_above_right)
#		return
#	# Ele left above should start sliding right
#	if above_above_left in map and TILE_ELEMENTS.is_fallale(map[above_above_left])\
#		and above_left in map and not above_left in falling_eles_at and TILE_ELEMENT.is_fallable(map[above_left])\
#		and map[above_above] == TILE_ELEMENTS.Ele.EMPTY and map[above] == TILE_ELEMENTS.Ele.EMPTY\
#		and not (above_above_right in falling_eles_at and TILE_ELEMENTS.is_fallable(map)):
#		falling_eles_at.append(above_above_left)
#
#func simulate_one_turn_v1(map: Dictionary, falling_eles_at: Array[Vector2] curr_pos: Vector2, new_pos: Vector2) -> bool:
#	var curr_map: Dictionary = map.duplicate(true)
#	var curr_falling_eles_at: Array[Vector2] = falling_eles_at.duplicate(true)
#	falling_eles_at.clear()
#	map[curr_pos] = TILE_ELEMENTS.Ele.EMPTY
#	map[new_pos] = TILE_ELEMENTS.Ele.PLAYER
#	_check_for_falling(curr_pos)
#
#	return true

func _can_push(map: Dictionary, curr_pos: Vector2, new_pos: Vector2) -> bool:
	var dir: Vector2 = new_pos - curr_pos
	return map[new_pos] == TILE_ELEMENTS.Ele.BOULDER and Dir2.is_horizontal(dir)\
		and ((new_pos + dir) in map and map[new_pos + dir] == TILE_ELEMENTS.Ele.EMPTY)

func simulate_one_turn(map: Dictionary, falling_eles_at: Array[Vector2], curr_pos: Vector2, new_pos: Vector2, width: int, height: int) -> SimRes:
	return simulate_one_turn_opt(map, map.duplicate(true), falling_eles_at, falling_eles_at.duplicate(true), curr_pos, new_pos, width, height)

enum SimRes {
	FAIL,
	PUSH,
	MOVE,
	STAY
}

func simulate_one_turn_opt(map: Dictionary, curr_map: Dictionary, falling_eles_at: Array[Vector2], curr_falling_eles_at: Array[Vector2], curr_pos: Vector2, new_pos: Vector2, width: int, height: int) -> SimRes:
	falling_eles_at.clear()
	var pushed_to: Vector2 = Vector2(-1, -1)
	var potential_res: SimRes
	if curr_pos == new_pos:
		potential_res = SimRes.STAY
	elif _can_push(curr_map, curr_pos, new_pos):
		map[curr_pos] = TILE_ELEMENTS.Ele.EMPTY
		map[new_pos] = TILE_ELEMENTS.Ele.PLAYER
		pushed_to = new_pos + (new_pos - curr_pos)
		map[pushed_to] = curr_map[new_pos]
		potential_res = SimRes.PUSH
	elif TILE_ELEMENTS._can_move_to(curr_map[new_pos]):
		map[curr_pos] = TILE_ELEMENTS.Ele.EMPTY
		map[new_pos] = TILE_ELEMENTS.Ele.PLAYER
		potential_res = SimRes.MOVE
	else:
		# Not possible to move anymore
		return SimRes.FAIL
	
	# Nothing can fall nor slide if it's on the lowest level so we can start one above
	for y in range(height-2, -1, -1):
		for x in range(width-1, -1, -1):
			var pos: Vector2 = Vector2(x, y)
			if not TILE_ELEMENTS.is_fallable(curr_map[pos]) or pos == curr_pos or pos == pushed_to:
				# Either noop or being involved in the player's turn
				continue
			# Vectors
			var below: Vector2 = pos + Vector2.DOWN
			var left: Vector2 = pos + Vector2.LEFT
			var left_below: Vector2 = below + Vector2.LEFT
			var right: Vector2 = pos + Vector2.RIGHT
			var right_below: Vector2 = below + Vector2.RIGHT
			# Try kill player
			if below == new_pos and pos in curr_falling_eles_at:
				return SimRes.FAIL
			# Try fall
			elif curr_map[below] == TILE_ELEMENTS.Ele.EMPTY:
				map[below] = curr_map[pos]
				map[pos] = TILE_ELEMENTS.Ele.EMPTY
				falling_eles_at.append(below)
			# Try slide left
			elif left in curr_map and TILE_ELEMENTS.is_fallable(curr_map[below]) and map[below] == curr_map[below]\
				and curr_map[left] == TILE_ELEMENTS.Ele.EMPTY and curr_map[left_below] == TILE_ELEMENTS.Ele.EMPTY:
				map[left_below] = curr_map[pos]
				map[pos] = TILE_ELEMENTS.Ele.EMPTY
				falling_eles_at.append(left_below)
			# Try slide right
			elif right in curr_map and TILE_ELEMENTS.is_fallable(curr_map[below]) and map[below] == curr_map[below]\
				and curr_map[right] == TILE_ELEMENTS.Ele.EMPTY and curr_map[right_below] == TILE_ELEMENTS.Ele.EMPTY:
				map[right_below] = curr_map[pos]
				map[pos] = TILE_ELEMENTS.Ele.EMPTY
				falling_eles_at.append(right_below)
	return potential_res
