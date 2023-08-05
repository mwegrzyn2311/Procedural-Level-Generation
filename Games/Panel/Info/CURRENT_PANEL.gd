extends Node


var width: int = 4
var height: int = 4
var max_tetromino_actions = 5

var panel_dict: Dictionary

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
	COLLECTION_UTIL.nice_print_dict(self.panel_dict)
