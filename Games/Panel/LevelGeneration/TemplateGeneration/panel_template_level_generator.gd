extends TemplateLevelGenerator

class_name PanelTemplateLevelGenerator

var START_TEMPLATES: LevelTemplates = PANEL_TEMPLATES.START_TEMPLATES_1

func _init(width: int, height: int, level_templates: LevelTemplates):
	super(width, height, level_templates)

func generate_level() -> Dictionary:
	var start_at: Vector2 = Vector2(0, RNG_UTIL.RNG.randi_range(0, height/t_height - 1))
	var offset: Vector2 = Vector2(0, start_at.y * t_height)
	var start_template: Dictionary = RNG_UTIL.choice(START_TEMPLATES.templates).duplicate(true)
	var res: Dictionary = {}
	for pos in start_template:
		res[pos + offset] = start_template[pos]
	res = super._generate_level(res, [start_at], false)
#	return make_ready_for_usage(res)
	return res

func _is_intersection(pos: Vector2) -> bool:
	return int(pos.x) % 2 == 0 and int(pos.y) % 2 == 0

func make_ready_for_usage(res: Dictionary) -> Dictionary:
	COLLECTION_UTIL.nice_print_dict(res)
	for pos in res:
		if res[pos] == PANEL_ELEMENTS.Ele.LINE:
			res[pos] = PANEL_ELEMENTS.Ele.INTERSECTION if _is_intersection(pos) else PANEL_ELEMENTS.Ele.PIPE
	# TODO: Find and mark exit
	# TODO: Fill bounderies
	return res
