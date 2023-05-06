extends Node
class_name LevelTemplates

var template_width: int = 1
var template_height: int = 1
var templates: Array = []
var template_neighbours: Dictionary = {}
var rotation_enabled: bool = true
var out_of_map_offset: Array[Vector2] = [Vector2.ZERO, Vector2.ZERO]

func _init(width: int, height: int, templates: Array, template_neighbours: Dictionary = {}, rotation_enabled: bool = true, out_of_map_offset: Array[Vector2] = [Vector2(0,0), Vector2(0,0)]):
	self.template_width = width
	self.template_height = height
	self.templates = templates
	self.template_neighbours = template_neighbours
	self.rotation_enabled = rotation_enabled
	self.out_of_map_offset = out_of_map_offset
