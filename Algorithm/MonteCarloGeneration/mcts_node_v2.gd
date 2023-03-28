#extends Node
#
#class_name MCTSNodeV2
#
#var state: MCTSGameState
#var parent: MCTSNode = null
#var parent_action: MCTSAction = null
#var children: Array[MCTSNode] = []
#var numberOfVisits: int = 0
#var results: Dictionary = {}
#var untried_actions: Array[MCTSAction] = []
#
#func _init(state: MCTSGameState, parent: MCTSNode=null, parent_action: MCTSAction=null):
#	self.state = state
#	self.parent = parent
#	self.parent_action = parent_action
#	self.untried_actions = state.legal_actions()
#
## main function for the Monte Carlo Tree Search
#func best_action():
#	for i in range(100):
#	#while resources_left(time, computational power):
#		var leaf: MCTSNodeV2 = traverse()
#		var simulation_result = rollout(leaf)
#		backpropagate(leaf, simulation_result)
#
#	return best_child()
#
## function for node traversal
#func traverse() -> MCTSNodeV2:
#	var node: MCTSNodeV2 = self
#	while node.is_fully_expanded():
#		node = best_uct(node)
#	# in case no children are present / node is terminal
#	var children_with_no_visits = node.children.filter()
#	return pick_unvisited(node.children) or node
#
#func is_fully_expanded() -> bool:
#	print("he")
#	print("Is fully expanded? %s (%d)" % ["true" if self.untried_actions.is_empty() else "false", self.untried_actions.size()])
#	return self.untried_actions.is_empty()
#
## function for the result of the simulation
#func rollout(node):
#	while not node.is_generation_completed():
#		node = rollout_policy(node)
#	return result(node)
#
## function for randomly selecting a child node
#func rollout_policy(node):
#	return pick_random(node.children)
#
## function for backpropagation
#func backpropagate(node, result):
#	if node.parent == null:
#		return
#	node.stats = update_stats(node, result)
#	backpropagate(node.parent)
#
#func best_utc():
#	pass
#
## function for selecting the best child
## node with highest number of visits
#func children_compare(a: MCTSNode, b: MCTSNode) -> bool:
#	return a.value() > b.value()
#
#func best_child():
#	print(self.children.size())
#	self.children.sort_custom(children_compare)
#	return self.children[0]
