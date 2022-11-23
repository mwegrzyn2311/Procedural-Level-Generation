extends Node
class_name TemplateUtils

var tile_vectors: Array
var neighbour_constraint_vectors: Array
var constraint_rotation_vectors: Array
var rotation_vectors: Array

static func from_level_templates(level_templates: LevelTemplates) -> TemplateUtils:
	return TemplateUtils.new(level_templates.template_width, level_templates.template_height)

func _init(width: int, height: int):
	self.tile_vectors = self.gen_tile_vectors(width, height)
	self.rotation_vectors = self.gen_rotation_vectors(width, height)
	self.neighbour_constraint_vectors = self.gen_neighbour_constraint_vectors(width, height)
	self.constraint_rotation_vectors = self.gen_constraint_rotation_vectors(width, height)
	
	assert(tile_vectors.size() == rotation_vectors[0].size())

func gen_tile_vectors(width: int, height: int) -> Array:
	var res = []
	for j in range(height):
		for i in range(width):
			res.append(Vector2(i, j))
	return res
	
# TODO: Consider diagonals
func gen_neighbour_constraint_vectors(width: int, height: int) -> Array:
	var res = []
	for i in range(width):
		res.append(Vector2(i, -1))
	for j in range(height):
		res.append(Vector2(3, j))
	for i in range(width-1, -1, -1):
		res.append(Vector2(i, 3))
	for j in range(height-1, -1, -1):
		res.append(Vector2(-1, j))
	return res
	
func gen_constraint_rotation_vectors(width: int, height: int) -> Array:
	assert(width == height, "templates with width != height not supported yet")
	var res = []
	var len = self.neighbour_constraint_vectors.size()
	res.append(Array(self.neighbour_constraint_vectors))
	for i in range(3, 0, -1):
		res.append(self.neighbour_constraint_vectors.slice(i * width, len) + self.neighbour_constraint_vectors.slice(0, i * width))
	for i in range(4):
		var arr: Array = res[(i + 3) % 4].duplicate(true)
		arr.reverse()
		res.append(arr)
	return res

# TODO: Switch from hardcoded for 3x3 to universally calculated
# TODO: Consider extracting
func gen_rotation_vectors(width: int, height: int) -> Array:
	# Order here has crucial importance!
	return [
		# 0 degree
		[
			Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), 
			Vector2(0, 1), Vector2(1, 1), Vector2(2, 1),
			Vector2(0, 2), Vector2(1, 2), Vector2(2, 2)
		],
		# 90 degree
		[
			Vector2(0, 2), Vector2(0, 1), Vector2(0, 0), 
			Vector2(1, 2), Vector2(1, 1), Vector2(1, 0),
			Vector2(2, 2), Vector2(2, 1), Vector2(2, 0)
		],
		# 180 degree
		[
			Vector2(2, 2), Vector2(1, 2), Vector2(0, 2), 
			Vector2(2, 1), Vector2(1, 1), Vector2(1, 0),
			Vector2(2, 0), Vector2(1, 0), Vector2(0, 0)
		],
		# 270 degree
		[
			Vector2(2, 0), Vector2(2, 1), Vector2(2, 2), 
			Vector2(1, 0), Vector2(1, 1), Vector2(1, 2),
			Vector2(0, 0), Vector2(0, 1), Vector2(0, 2)
		],
		# 0 degree + horizontal tilt
		[
			Vector2(2, 0), Vector2(1, 0), Vector2(0, 0), 
			Vector2(2, 1), Vector2(1, 1), Vector2(0, 1),
			Vector2(2, 2), Vector2(1, 2), Vector2(0, 2)
		],
		# 90 degree + horizontal tilt
		[
			Vector2(0, 0), Vector2(0, 1), Vector2(0, 2), 
			Vector2(1, 0), Vector2(1, 1), Vector2(1, 2),
			Vector2(2, 0), Vector2(2, 1), Vector2(2, 2)
		],
		# 180 degree + horizontal tilt
		[
			Vector2(0, 2), Vector2(1, 2), Vector2(2, 2), 
			Vector2(0, 1), Vector2(1, 1), Vector2(2, 1),
			Vector2(0, 0), Vector2(1, 0), Vector2(2, 0)
		],
		# 270 degree + horizontal tilt
		[
			Vector2(2, 2), Vector2(2, 1), Vector2(2, 0), 
			Vector2(1, 2), Vector2(1, 1), Vector2(1, 0),
			Vector2(0, 2), Vector2(0, 1), Vector2(0, 0)
		],
	]

func rotate_template(template: Dictionary, rotation_index: int) -> Dictionary:
	var res: Dictionary = {}
	for tile_i in range(tile_vectors.size()):
		res[tile_vectors[tile_i]] = template[rotation_vectors[rotation_index][tile_i]]
	# Place template tiles that ensure good template connections
	for tile_i in range(neighbour_constraint_vectors.size()):
		if template.has(constraint_rotation_vectors[rotation_index][tile_i]):
			res[neighbour_constraint_vectors[tile_i]] = template[constraint_rotation_vectors[rotation_index][tile_i]]
			
	return res
