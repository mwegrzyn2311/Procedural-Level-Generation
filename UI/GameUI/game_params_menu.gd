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
	var info_script = NAVIGATION.GAME_TO_INFO_SCRIPT[MENU_INFO.selectedGame]
	info_script.set_width(widthInput.get_int_value())
	info_script.set_height(heightInput.get_int_value())
	info_script.apply()
	get_tree().change_scene_to_file(NAVIGATION.getGameScene(MENU_INFO.selectedGame))
