extends Node

const POS_NOT_FOUND = Vector2(-1, -1)
@onready var ELEMENTS_TO_PLACE: Array[TILE_ELEMENTS.Ele]

func _ready():
	ELEMENTS_TO_PLACE = [TILE_ELEMENTS.Ele.GRASS, TILE_ELEMENTS.Ele.GRASS, TILE_ELEMENTS.Ele.GRASS, TILE_ELEMENTS.Ele.POINT]

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

# TODO: VERIFY
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


