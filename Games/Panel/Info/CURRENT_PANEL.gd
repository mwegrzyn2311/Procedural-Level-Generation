extends Node


var width: int = 4
var height: int = 4

var panel_dict: Dictionary = {}

var level_generator: LevelGenerator = null

func set_width(width: int):
	self.width = width
	
func set_height(height: int):
	self.height = height
	
func apply():
	if MENU_INFO.selectedAlgo == CONSTANTS.SupportedAlgos.TEMPLATE_BASED:
		level_generator = PanelTemplateLevelGenerator.new(width, height, SUPAPLEX_TEMPLATES.TEMPLATES_6)
	elif MENU_INFO.selectedAlgo == CONSTANTS.SupportedAlgos.MONTE_CARLO:
		level_generator = PanelMCTSLevelGenerator.new(width, height)

func generate_map():
	self.panel_dict = level_generator.generate_level()
