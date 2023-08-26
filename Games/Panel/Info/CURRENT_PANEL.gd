extends Node


var width: int = 4
var height: int = 4
var max_tetromino_actions = 4
var is_one_by_one_tetromino_disabled: bool = true

# Dictionary[Vector2, PANEL_ELEMENTS.Ele]
var panel_dict: Dictionary
# Dictionary[Vector2, TETROMINO_UTIL.Type]
var tetrominos: Dictionary

var level_generator: LevelGenerator = PanelMockGenerator.new()

func set_width(width: int):
	self.width = (width * 2) - 1
	
func set_height(height: int):
	self.height = (height * 2) - 1
	
func apply():
	if MENU_INFO.selectedAlgo == CONSTANTS.SupportedAlgos.TEMPLATE_BASED:
		level_generator = PanelTemplateLevelGenerator.new(width, height, PANEL_TEMPLATES.TEMPLATES_2)
	elif MENU_INFO.selectedAlgo == CONSTANTS.SupportedAlgos.MONTE_CARLO:
		level_generator = PanelMCTSLevelGenerator.new(width, height)
	else:
		level_generator = PanelMockGenerator.new()

func generate_map():
	self.panel_dict = level_generator.generate_level()
	self.tetrominos = {}
	for pos in panel_dict:
		if panel_dict[pos] is Tetromino:
			self.tetrominos[pos] = panel_dict[pos].type
	COLLECTION_UTIL.nice_print_dict(self.panel_dict)
