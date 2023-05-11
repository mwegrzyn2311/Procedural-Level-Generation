extends Node

class_name MCTSAction


var function: Callable
var args: Dictionary

func _init(function: Callable, args: Dictionary):
	self.function = function
	self.args = args
	
func apply():
	return self.function.call(self.args)
