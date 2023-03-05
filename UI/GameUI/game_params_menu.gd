extends Control


@onready var widthInput: NumericInput = $Margin/Contents/Interactive/VBoxContainer/GridContainer/WidthInput
@onready var heightInput: NumericInput = $Margin/Contents/Interactive/VBoxContainer/GridContainer/HeightInput

func _ready():
	if MENU_INFO.selectedAlgo == CONSTANTS.SupportedAlgos.TEMPLATE_BASED:
		widthInput.step = 3
		heightInput.step = 3

func _on_back_button_pressed():
	get_tree().change_scene_to_file(NAVIGATION.GAME_SELECTION)

func _on_start_button_pressed():
	CURRENT_LEVEL_INFO.set_width(widthInput.get_int_value())
	CURRENT_LEVEL_INFO.set_height(heightInput.get_int_value())
	CURRENT_LEVEL_INFO.apply()
	get_tree().change_scene_to_file(NAVIGATION.getGameScene(MENU_INFO.selectedGame))
	
