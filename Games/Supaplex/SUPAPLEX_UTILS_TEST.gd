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
	var all_tests_passed: bool = true
	for i in range(scenarios.size()):
		if _test_scenario(scenarios[i]):
			print("SUPAPLEX_UTILS test scenario " + str(i) + " passed")
		else:
			all_tests_passed = false
			print("SUPAPLEX_UTILS test scenario " + str(i) + " not passed")
		
	print("All SUPAPLEX_UTILS tests passed" if all_tests_passed else "Some SUPAPLEX_UTILS tests failed")

func v(x: int, y: int):
	return Vector2(x, y)

func _test_scenario(scenario: Scenario) -> bool:
	return SUPAPLEX_UTILS.simulate_gameplay(scenario.placed_elements, scenario.player_pos_history) == scenario.expected_output

