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
	
	for i in range(simulations):
		self.rollout()
	
	return self.most_visited_child()
	
func tree_policy():
	while not self.is_fully_expanded():
		self.expand()
	return self.best_child()
	
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
		curr_node = curr_node.tree_policy()
	var reward = curr_node.state.generation_result()
	curr_node.backpropagate(reward)

func backpropagate(result):
	self.numberOfVisits += 1
	self.results[result] = COLLECTION_UTIL.dict_get_or_default(self.results, result, 0) + 1
	if self.parent:
		self.parent.backpropagate(result)

func value() -> float:
	if numberOfVisits == 0:
		return 999999999999.0
	# TODO: Might have to be normalized to one
	var val = 0.0
	for result in self.results:
		val += result * self.results[result]
	return ((val / numberOfVisits) + sqrt(2 * log(parent.numberOfVisits) / numberOfVisits))
	
func children_compare(a: MCTSNode, b: MCTSNode) -> bool:
	if a.value() == b.value():
		return RNG_UTIL.rand_bool()
	else:
		return a.value() > b.value()

func best_child():
	self.children.sort_custom(children_compare)
	return self.children[0]
	
func children_compare_visits(a: MCTSNode, b: MCTSNode) -> bool:
	return a.numberOfVisits > b.numberOfVisits
	
func most_visited_child():
	if children.is_empty():
		return self
	else:
		self.children.sort_custom(children_compare_visits)
		return self.children[0].most_visited_child()

func is_terminal_node():
	return self.state.is_generation_completed()
