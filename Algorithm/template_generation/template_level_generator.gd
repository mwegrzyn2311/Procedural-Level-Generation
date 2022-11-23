extends Node
class_name TemplateLevelGenerator

# This class is responsile for generating levels from rectangular w x h tile templates
# It should be extended to implement game-specific adjustments

var template_utils: TemplateUtils

var width: int = 1
var height: int = 1
var t_width: int = 1
var t_height: int = 1
var level_templates: LevelTemplates

func _init(width: int, height: int, level_templates: LevelTemplates):
	self.template_utils = TemplateUtils.from_level_templates(level_templates)
	self.width = width
	self.height = height
	self.t_width = level_templates.template_width
	self.t_height = level_templates.template_height
	self.level_templates = level_templates

# TODO: I think that with some templates it's possible to get an occurence that no template would fit which leads to inifite loop
# TODO: It'd also be good to not pick the same template with the same rotation twice but with so many choices it might consume some memory and maybe even time...
func generate_level() -> Dictionary:
	var templates: Array = level_templates.templates
	
	var tiles_vert: int = self.height/t_height
	var tiles_horiz: int = self.width/t_width
	
	var templates_count = templates.size()
	var rotations_count = template_utils.rotation_vectors.size()
	var res: Dictionary = {}
	# Start off by building levels out of random templates
	for j in range(tiles_vert):
		for i in range(tiles_horiz):
			var template_chosen: bool = false
			while !template_chosen:
				var template_index: int = RNG_UTIL.RNG.randi_range(0, templates_count - 1)
				var rotation_index: int = RNG_UTIL.RNG.randi_range(0, rotations_count - 1)
				var rotation: Array = template_utils.rotation_vectors[rotation_index]
				var neighbour_constraint_rotation = template_utils.constraint_rotation_vectors[rotation_index]
				var template: Dictionary = templates[template_index]
				var base: Vector2 = Vector2(i * t_width, j * t_height)
				if template_fits(base, res, template, rotation, neighbour_constraint_rotation):
					template_chosen = true
					# Place template tiles
					for tile_i in range(template_utils.tile_vectors.size()):
						res[base + template_utils.tile_vectors[tile_i]] = template[rotation[tile_i]]
					# Place template tiles that ensure good template connections
					for tile_i in range(template_utils.neighbour_constraint_vectors.size()):
						if template.has(neighbour_constraint_rotation[tile_i]):
							res[base + template_utils.neighbour_constraint_vectors[tile_i]] = template[neighbour_constraint_rotation[tile_i]]
	return res
	
func template_fits(base: Vector2, map: Dictionary, template: Dictionary, rotation: Array, neighbour_constraint_rotation: Array) -> bool:
	# Start by checking if there would appear a different type of tile on existing tile
	for tile_i in range(template_utils.tile_vectors.size()):
		var pos: Vector2 = base + template_utils.tile_vectors[tile_i]
		if map.has(pos) and map[pos] != template[rotation[tile_i]]:
			return false
	# Then check if neighbours don't overlap
	for tile_i in range(template_utils.neighbour_constraint_vectors.size()):
		var pos: Vector2 = base + template_utils.neighbour_constraint_vectors[tile_i]
		if template.has(neighbour_constraint_rotation[tile_i]) and (!is_in_map(pos) or (map.has(pos) and map[pos] != template[neighbour_constraint_rotation[tile_i]])):
			return false
	return true
			
func is_in_map(pos: Vector2) -> bool:
	return pos.x >= 0 and pos.x < self.width and pos.y >= 0 and pos.y < self.height
