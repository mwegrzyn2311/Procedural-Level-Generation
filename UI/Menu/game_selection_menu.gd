extends Control

@onready var game_select: OptionButton = $Margin/Contents/Interactive/VBox/GridContainer/GameSelect
@onready var algo_select: OptionButton = $Margin/Contents/Interactive/VBox/GridContainer/AlgoSelect
@onready var seed_input: NumericInput = $Margin/Contents/Interactive/VBox/GridContainer/SeedInput

# Called when the node enters the scene tree for the first time.
func _ready():
	MENU_INFO.selectedGame = -1
	MENU_INFO.selectedAlgo = -1
	for game in CONSTANTS.SupportedGames.keys():
		game_select.add_item(game)
	game_select.selected = -1

func _on_back_button_pressed():
	get_tree().change_scene_to_file(NAVIGATION.MAIN_MENU)

func _on_next_button_pressed():
	if required_inputs_filled():
		MENU_INFO.selectedGame = game_select.selected
		MENU_INFO.selectedAlgo = algo_select.selected
		RNG_UTIL.set_seed(seed_input.get_int_value())
		get_tree().change_scene_to_file(NAVIGATION.getParamsSelectionMenu(MENU_INFO.selectedGame, MENU_INFO.selectedAlgo))

func required_inputs_filled() -> bool:
	return game_select.selected != -1 and algo_select.selected != -1


func _on_game_select_item_selected(index):
	algo_select.clear()
	for algo in CONSTANTS.ALGOS_PER_GAME.get(index):
		algo_select.add_item(CONSTANTS.SupportedAlgos.keys()[algo])
