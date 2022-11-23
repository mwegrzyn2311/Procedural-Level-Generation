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
			print("=====")
			while !template_chosen:
				print("choosing...")
				var template_index: int = RNG_UTIL.RNG.randi_range(0, templates_count - 1)
				var rotation_index: int = RNG_UTIL.RNG.randi_range(0, rotations_count - 1)
				var rotated_template: Dictionary = template_utils.rotate_template(templates[template_index], rotation_index)
				var base: Vector2 = Vector2(i * t_width, j * t_height)
				#print("%d, %d" % [template_index, rotation_index])
				if template_fits(base, res, rotated_template):
					template_chosen = true
					# Place template tiles
					for pos in rotated_template:
						res[base + pos] = rotated_template[pos]
	return res
	
func template_fits(base: Vector2, map: Dictionary, template: Dictionary) -> bool:
	for pos in template:
		if !is_in_map(base + pos):
			return false
		elif map.has(base + pos) and map[base + pos] != template[pos]:
			return false
	return true
			
func is_in_map(pos: Vector2) -> bool:
	return pos.x >= 0 and pos.x < self.width and pos.y >= 0 and pos.y < self.height
