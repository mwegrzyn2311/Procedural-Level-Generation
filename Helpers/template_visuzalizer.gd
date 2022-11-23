extends ScrollContainer

# TODO: Remove testing containers (visible only in editor)

var level_templates: LevelTemplates
var template_utils: TemplateUtils
@onready var templates_container: GridContainer = $Templates
@onready var ref_rects_layer: CanvasLayer = $RefRectsLayer
const OBJECTS_IN_A_ROW = 20
var template_cont_size: Vector2
var ref_frame_size: Vector2
const ref_frame_offset: Vector2 = Vector2(1.5 * CONSTANTS.TILE_SIZE, 1.5 * CONSTANTS.TILE_SIZE)

func _ready():
	set_level_templates(SUPAPLEX_TEMPLATES.TEMPLATES_5)
	
func set_level_templates(level_templates: LevelTemplates):
	self.level_templates = level_templates
	self.template_utils = TemplateUtils.from_level_templates(level_templates)
	adjust_sizes(level_templates)
	redraw_templates()

func adjust_sizes(level_templates: LevelTemplates):
	var columns: int = 8 # For each rotation
	var rows: int = level_templates.templates.size()
	self.templates_container.columns = columns
	# +3 is here for constraints and margins
	self.ref_frame_size = Vector2(
		level_templates.template_width * CONSTANTS.TILE_SIZE,
		level_templates.template_height * CONSTANTS.TILE_SIZE)
	self.template_cont_size = Vector2(
		(level_templates.template_width + 3) * CONSTANTS.TILE_SIZE,
		(level_templates.template_height + 3) * CONSTANTS.TILE_SIZE)

func redraw_templates():
	clear_view()
	for index in level_templates.templates.size():
		# TODO: Here should apply rotations
		for i in range(8):
			visualizeLevelTemplate(template_utils.rotate_template(level_templates.templates[index], i), i, index)

# TODO: Extract as a helper function to sth like COMMONS/NODE_UTIL
func clear_view():
	for template in templates_container.get_children():
		templates_container.remove_child(template)
		template.queue_free()
	for ref_rect in ref_rects_layer.get_children():
		ref_rects_layer.remove_child(ref_rect)
		ref_rect.queue_free()

func visualizeLevelTemplate(level_template: Dictionary, x: int, y: int):
	var container = create_template_cont(x, y)
	create_border_frame(x, y)
	var tiles: Array = LEVEL_CONVERTER.vec_string_dict_to_tile_arr_with_offset(level_template, Vector2(1, 1))
	for tile in tiles:
		container.add_child(tile)
	templates_container.add_child(container)

func create_template_cont(x: int, y: int) -> ColorRect:
	var container = ColorRect.new()
	container.custom_minimum_size = self.template_cont_size
	container.color = get_color(x, y)
	return container
	
func create_border_frame(x: int, y: int):
	var frame = ReferenceRect.new()
	frame.border_color = Color(1, 1, 1, 1)
	frame.border_width = 4
	frame.editor_only = false
	frame.custom_minimum_size = self.ref_frame_size
	frame.set_position(Vector2(
		(template_cont_size.x + 4) * x,
		(template_cont_size.y + 4) * y
		) + self.ref_frame_offset)
	ref_rects_layer.add_child(frame)
	
func get_color(x: int, y: int) -> Color:
	if y%2 == 0:
		if x%2 == 0:
			return Color(0.3, 0.3, 0.3, 1)
		else:
			return Color(0.6, 0.6, 0.6, 1)
	else:
		if x%2 == 0:
			return Color(0.5, 0.9, 0.9, 1)
		else:
			return Color(0.8, 0.8, 0.1, 1)
