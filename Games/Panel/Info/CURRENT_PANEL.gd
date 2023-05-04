extends Node


var width: int = 4
var height: int = 4

var panel_dict: Dictionary

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
	#self.panel_dict = level_generator.generate_level()
	self.panel_dict = {
		Vector2(0,0): PANEL_ELEMENTS.Ele.START, Vector2(1, 0): PANEL_ELEMENTS.Ele.PIPE, Vector2(2, 0): PANEL_ELEMENTS.Ele.INTERSECTION, Vector2(3, 0): PANEL_ELEMENTS.Ele.EMPTY, Vector2(4, 0): PANEL_ELEMENTS.Ele.INTERSECTION,
		Vector2(0,1): PANEL_ELEMENTS.Ele.PIPE, Vector2(1, 1): PANEL_ELEMENTS.Ele.EMPTY, Vector2(2, 1): PANEL_ELEMENTS.Ele.PIPE, Vector2(3, 1): PANEL_ELEMENTS.Ele.EMPTY, Vector2(4, 1): PANEL_ELEMENTS.Ele.PIPE,
		Vector2(0,2): PANEL_ELEMENTS.Ele.INTERSECTION, Vector2(1, 2): PANEL_ELEMENTS.Ele.PIPE, Vector2(2, 2): PANEL_ELEMENTS.Ele.INTERSECTION, Vector2(3, 2): PANEL_ELEMENTS.Ele.PIPE, Vector2(4, 2): PANEL_ELEMENTS.Ele.INTERSECTION,
		Vector2(0,3): PANEL_ELEMENTS.Ele.PIPE, Vector2(1, 3): PANEL_ELEMENTS.Ele.EMPTY, Vector2(2, 3): PANEL_ELEMENTS.Ele.EMPTY, Vector2(3, 3): PANEL_ELEMENTS.Ele.EMPTY, Vector2(4, 3): PANEL_ELEMENTS.Ele.PIPE,
		Vector2(0,4): PANEL_ELEMENTS.Ele.INTERSECTION, Vector2(1, 4): PANEL_ELEMENTS.Ele.PIPE, Vector2(2, 4): PANEL_ELEMENTS.Ele.INTERSECTION, Vector2(3, 4): PANEL_ELEMENTS.Ele.PIPE, Vector2(4, 4): PANEL_ELEMENTS.Ele.INTERSECTION,
	}
