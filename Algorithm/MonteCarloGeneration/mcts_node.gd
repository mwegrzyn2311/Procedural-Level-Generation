extends Node

class_name MCTSNode


var state: MCTSGameState
var parent: MCTSNode = null
var parent_action: MCTSAction = null
var children: Array[MCTSNode] = []
var numberOfVisits: int = 0
var results: Dictionary = {}
var untried_actions: Array[MCTSAction] = []

func _init(state: MCTSGameState, parent: MCTSNode=null, parent_action: MCTSAction=null):
	self.state = state
	self.parent = parent
	self.parent_action = parent_action
	self.untried_actions = state.legal_actions()

func expand() -> MCTSNode:
	var action = self.untried_actions.pop_front()
	var next_state: MCTSGameState = self.state.move(action)
	var child_node: MCTSNode = create_child_node(action, next_state)
	self.children.append(child_node)
	return child_node
	
func create_child_node(action, next_state) -> MCTSNode:
	return MCTSNode.new(next_state, self, action)
	
func rollout() -> float:
	var curr_rollout_state: MCTSGameState = self.state
	
	while not curr_rollout_state.is_generation_completed():
		var possible_moves: Array = curr_rollout_state.legal_actions()
		var action = self.rollout_policy(possible_moves)
		curr_rollout_state = curr_rollout_state.move(action)
	return curr_rollout_state.generation_result()

# TODO: Experiment with rollout_policies other than random
func rollout_policy(possible_moves: Array):
	return RNG_UTIL.choice(possible_moves)

func tree_policy():
	var curr_node: MCTSNode = self
	while not curr_node.is_terminal_node():
		if not curr_node.is_fully_expanded():
			return curr_node.expand()
		else:
			curr_node = curr_node.best_child()
	return curr_node
	
func backpropagate(result):
	self.numberOfVisits += 1
	self.results[result] = COLLECTION_UTIL.dict_get_or_default(self.results, result, 0) + 1
	if self.parent:
		self.parent.backpropagate(result)

func is_fully_expanded() -> bool:
	return self.untried_actions.is_empty()

func best_action():
	# TODO: Investigage if statement below is true
	# There are many simulations because of random choose policy, I think
	const simulations: int = 100
	
	for i in range(simulations):
		var node: MCTSNode = self.tree_policy()
		var reward = node.rollout()
		node.backpropagate(reward)
	
	return self.best_child()
	
func value() -> float:
	var val = 0.0
	for result in self.results:
		val += result * self.results[result]
	return ((val / numberOfVisits) + 0.9 * sqrt(2 * log(numberOfVisits) / numberOfVisits))
	
func children_compare(a: MCTSNode, b: MCTSNode) -> bool:
	return a.value() > b.value()

func best_child():
	self.children.sort_custom(children_compare)
	return self.children[0]

func is_terminal_node():
	return self.state.is_generation_completed()
