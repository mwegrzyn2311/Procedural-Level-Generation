extends Node

class_name MCTSAction


var function: Callable
var args: Dictionary

func _init(function: Callable, args: Dictionary):
	self.function = function
	self.args = args
	
func apply():
	self.function.call(self.args)
