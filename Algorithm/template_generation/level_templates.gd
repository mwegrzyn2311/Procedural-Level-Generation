extends Node
class_name LevelTemplates

var template_width: int = 1
var template_height: int = 1
var templates: Array = []
var template_neighbours: Dictionary = {}

func _init(width: int, height: int, templates: Array, template_neighbours: Dictionary = {}):
	self.template_width = width
	self.template_height = height
	self.templates = templates
	self.template_neighbours = template_neighbours
