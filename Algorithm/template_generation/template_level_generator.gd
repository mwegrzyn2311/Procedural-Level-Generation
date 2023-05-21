extends LevelGenerator
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
	var res: Dictionary = super.generate_level()
	var templates: Array = level_templates.templates
	
	var tiles_vert: int = self.height/t_height
	var tiles_horiz: int = self.width/t_width
	
	var templates_count = templates.size()
	var rotations_count = template_utils.rotation_vectors.size()
	# Start off by building levels out of random templates
	for j in range(tiles_vert):
		for i in range(tiles_horiz):
			var base: Vector2 = Vector2(i * t_width, j * t_height)
			var template_indices: Array = range(templates_count)
			var template_chosen: bool = false
			while !template_chosen and not template_indices.is_empty():
				var template_index: int = RNG_UTIL.choice(template_indices)
				var rotated_template: Dictionary = templates[template_index]
				if level_templates.rotation_enabled:
					var rotation_indices: Array = range(rotations_count)
					while not rotation_indices.is_empty():
						var rotation_index: int = RNG_UTIL.choice(rotation_indices)
						rotated_template = template_utils.rotate_template(templates[template_index], rotation_index)
						if template_fits(base, res, rotated_template):
							template_chosen = true
							break
						rotation_indices.remove_at(rotation_indices.find(rotation_index))
				else:
					if template_fits(base, res, rotated_template):
							template_chosen = true
				if template_chosen:
					# Place template tiles
					for pos in rotated_template:
						res[base + pos] = rotated_template[pos]
				template_indices.remove_at(template_indices.find(template_index))
			if not template_chosen:
				print(res)
			assert(template_chosen, "ERROR: Failed to find a matching template")
	return res
	
func template_fits(base: Vector2, map: Dictionary, template: Dictionary) -> bool:
	for pos in template:
		if !is_in_map(base + pos):
			return false
		elif map.has(base + pos) and map[base + pos] != template[pos]:
			return false
	return true
			
func is_in_map(pos: Vector2) -> bool:
	return pos.clamp(Vector2(0,0) + level_templates.out_of_map_offset[0], Vector2(width-1, height-1) + level_templates.out_of_map_offset[1]) == pos
