extends Node

class_name MCTSNode


var state: MCTSGameState
var parent: MCTSNode = null
var parent_action: MCTSAction = null
var children: Array[MCTSNode] = []
var numberOfVisits: int = 0
var results: Dictionary = {}
var untried_actions: Array = []

func _init(state: MCTSGameState, parent: MCTSNode=null, parent_action: MCTSAction=null):
	self.state = state
	self.parent = parent
	self.parent_action = parent_action
	self.untried_actions = state.legal_actions()

# TODO: Consider adding RAVE method

func best_action():
	# TODO: Change this to time-based?
	const simulations: int = 100
	var time_start = Time.get_unix_time_from_system()
	var time_now = Time.get_unix_time_from_system()
	
#	for i in range(simulations):
	var i: int = 0
	var time_limit: float = 3.0
#	while time_now - time_start < time_limit:
	for j in range(1000):
		i += 1
#		print(i)
		var node = tree_policy(self)
		var result = node.rollout()
		node.backpropagate(result)
		time_now = Time.get_unix_time_from_system()
		#print(time_now - time_start)
	
	var res = self.bestest_child()
	print(str(i) + " iterations over " + str(time_now - time_start) + " seconds and res with value of " + str(res.state.generation_result() / res.state.max_score()))
	return res

func tree_policy(node):
	while not node.is_terminal_node():
		if not node.is_fully_expanded():
			return node.expand()
		else:
			node = node.best_explor_child()
	return node
	
func is_fully_expanded() -> bool:
	return self.untried_actions.is_empty()
	
func expand():
	var action: MCTSAction = self.untried_actions.pop_front()
	var next_state: MCTSGameState = self.state.move(action)
	var child_node: MCTSNode = create_child_node(action, next_state)
	self.children.append(child_node)
	return child_node

func create_child_node(action: MCTSAction, next_state: MCTSGameState) -> MCTSNode:
	return MCTSNode.new(next_state, self, action)

func rollout():
	var curr_node = self

	while not curr_node.is_terminal_node():
		# random rollout
		var action: MCTSAction = RNG_UTIL.choice(curr_node.untried_actions)
		curr_node.untried_actions.erase(action)
		var next_state: MCTSGameState = curr_node.state.move(action)
		var child_node: MCTSNode = curr_node.create_child_node(action, next_state)
		curr_node.children.append(child_node)
		curr_node = child_node
	return curr_node.state.generation_result()

func backpropagate(result):
	self.numberOfVisits += 1
	self.results[result] = COLLECTION_UTIL.dict_get_or_default(self.results, result, 0) + 1
	if self.parent:
		self.parent.backpropagate(result)

func explor_value() -> float:
	# TODO: Might have to be normalized to one
	var val: float = 0.0
	for result in self.results:
		val += result * self.results[result]
	var value: float = (val / ((numberOfVisits) * state.max_score())) + 0.1 * sqrt(2 * log(parent.numberOfVisits) / (numberOfVisits))
	return value
	
func value() -> float:
	return self.results.keys().max() if not self.results.is_empty() else 0.0

static func node_explor_val(node: MCTSNode) -> float:
	return node.explor_value()

static func node_val(node: MCTSNode) -> float:
	return node.value();

func best_explor_child():
	return COLLECTION_UTIL.max_custom(self.children, node_explor_val)
	
func best_child():
	return COLLECTION_UTIL.max_custom(self.children, node_val)
	
func bestest_child():
	if is_terminal_node():
		return self
	else:
		return self.best_child().bestest_child()

func is_terminal_node():
	return self.state.is_generation_completed()
