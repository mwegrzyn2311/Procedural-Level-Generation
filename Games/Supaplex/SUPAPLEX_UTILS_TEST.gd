extends Node

const B: TILE_ELEMENTS.Ele = TILE_ELEMENTS.Ele.BOULDER
const G: TILE_ELEMENTS.Ele = TILE_ELEMENTS.Ele.GRASS
const X: TILE_ELEMENTS.Ele = TILE_ELEMENTS.Ele.EXIT
const O: TILE_ELEMENTS.Ele = TILE_ELEMENTS.Ele.EMPTY
const P: TILE_ELEMENTS.Ele = TILE_ELEMENTS.Ele.PLAYER

class Scenario:
	# Dictionary[Vector2, TILE_ELEMENT.Ele]
	var placed_elements: Dictionary
	var player_pos_history: Array[Vector2]
	var expected_output: bool
	
	func _init(placed_elements: Dictionary, player_pos_history: Array[Vector2], expected_output: bool):
		self.placed_elements = placed_elements
		self.player_pos_history = player_pos_history
		self.expected_output = expected_output

class OneTurnScenario:
	var map: Dictionary
	var falling_eles_at: Array[Vector2]
	var curr_pos: Vector2
	var new_pos: Vector2
	var expected_res: SUPAPLEX_UTILS.SimRes
	var expected_map: Dictionary
	var expected_falling_eles_at: Array[Vector2]
	var width: int
	var height: int
	
	func _init(map: Dictionary, falling_eles_at: Array[Vector2], curr_pos: Vector2, new_pos: Vector2,\
		expected_res: SUPAPLEX_UTILS.SimRes, expected_map: Dictionary, expected_falling_eles_at: Array[Vector2],\
		width: int, height: int):
		self.map = map
		self.falling_eles_at = falling_eles_at
		self.curr_pos = curr_pos
		self.new_pos = new_pos
		self.expected_res = expected_res
		self.expected_map = expected_map
		self.expected_falling_eles_at = expected_falling_eles_at
		self.width = width
		self.height = height

func _ready():
	var scenarios: Array[Scenario] = [
		Scenario.new({
			v(0,0): B, v(1, 0): B, v(2,0): B, v(3,0): B,
			v(0,1): G, v(1, 1): G, v(2,1): G, v(3,1): G,
			v(0,2): G,
			v(0,3): G,
			v(0,4): X
			},
			[v(0,4), v(0,3), v(0,2), v(0,1), v(1,1), v(2,1), v(3,1), v(4,1)],
			true
		),
		Scenario.new({
			v(0,0): B, v(1, 0): B, v(2,0): B, v(3,0): B,
			v(0,1): G, v(1, 1): G, v(2,1): G, v(3,1): G,
			v(0,2): G,
			v(0,3): G,
			v(0,4): X
			},
			[v(0,4), v(0,3), v(0,2), v(0,1), v(0,1), v(1,1), v(1,1), v(2,1), v(2,1), v(3,1), v(3,1), v(4,1), v(4,1)],
			true
		),
		Scenario.new({
			v(0,0): B, v(1, 0): B, v(2,0): B, v(3,0): B,
			v(0,1): G, v(1, 1): G, v(2,1): G, v(3,1): G,
			v(0,2): G,
			v(0,3): G,
			v(0,4): X
			},
			[v(0,4), v(0,3), v(0,2), v(0,2), v(0,1), v(1,1), v(2,1), v(3,1), v(4,1)],
			false
		),
		Scenario.new({
			v(0,0): B, v(1, 0): B, v(2,0): B, v(3,0): B,
			v(0,1): G, v(1, 1): G, v(2,1): G, v(3,1): G,
			v(0,2): G,
			v(0,3): G,
			v(0,4): X
			},
			[v(0,4), v(0,3), v(0,2), v(0,2), v(0,2), v(0,1), v(1,1), v(2,1), v(3,1), v(4,1)],
			false
		)
	]
	var one_turn_scenarios: Array[OneTurnScenario] = [
		# Basic move
		OneTurnScenario.new(
		{
			v(0, 0): P, v(1, 0): O
		},
		[],
		v(0,0), v(1, 0),
		SUPAPLEX_UTILS.SimRes.MOVE,
		{
			v(0, 0): O, v(1, 0): P
		},
		[],
		2, 1
		),
		# Basic stay in place
		OneTurnScenario.new(
		{
			v(0, 0): P, v(1, 0): O
		},
		[],
		v(0,0), v(0, 0),
		SUPAPLEX_UTILS.SimRes.STAY,
		{
			v(0, 0): P, v(1, 0): O
		},
		[],
		2, 1
		),
		# Basic push right
		OneTurnScenario.new(
		{
			v(0, 0): P, v(1, 0): B, v(2, 0): O
		},
		[],
		v(0,0), v(1, 0),
		SUPAPLEX_UTILS.SimRes.PUSH,
		{
			v(0, 0): O, v(1, 0): P, v(2, 0): B
		},
		[],
		3, 1
		),
		# Basic can't push right
		OneTurnScenario.new(
		{
			v(0, 0): P, v(1, 0): B, v(2, 0): G
		},
		[],
		v(0,0), v(1, 0),
		SUPAPLEX_UTILS.SimRes.FAIL,
		{
			v(0, 0): P, v(1, 0): B, v(2, 0): G
		},
		[],
		3, 1
		),
	]
	var all_tests_passed: bool = true
	for i in range(scenarios.size()):
		if _test_scenario(scenarios[i]):
			print("SUPAPLEX_UTILS#simulate_gameplay test scenario " + str(i) + " passed")
		else:
			all_tests_passed = false
			print("SUPAPLEX_UTILS#simulate_gameplay test scenario " + str(i) + " not passed")
	
	for i in range(one_turn_scenarios.size()):
		if _test_one_turn_scenario(one_turn_scenarios[i]):
			print("SUPAPLEX_UTILS#simulate_one_turn_opt test scenario " + str(i) + " passed")
		else:
			all_tests_passed = false
			print("SUPAPLEX_UTILS#simulate_one_turn_opt test scenario " + str(i) + " not passed")
		
	print("All SUPAPLEX_UTILS tests passed" if all_tests_passed else "Some SUPAPLEX_UTILS tests failed")
	
func v(x: int, y: int):
	return Vector2(x, y)

func _test_scenario(scenario: Scenario) -> bool:
	return SUPAPLEX_UTILS.simulate_gameplay(scenario.placed_elements, scenario.player_pos_history) == scenario.expected_output

func _test_one_turn_scenario(ots: OneTurnScenario) -> bool:
	var res = SUPAPLEX_UTILS.simulate_one_turn_opt(ots.map, ots.map.duplicate(true), ots.falling_eles_at,\
		ots.falling_eles_at.duplicate(true), ots.curr_pos, ots.new_pos, ots.width, ots.height)
	return res == ots.expected_res and ots.map == ots.expected_map and ots.falling_eles_at == ots.expected_falling_eles_at
