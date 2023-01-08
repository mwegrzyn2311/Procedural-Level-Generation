extends Node


const MAIN_MENU: String = "res://UI/Menu/main_menu.tscn"
const GAME_SELECTION: String = "res://UI/Menu/game_selection_menu.tscn"

var GAME_TO_SCENE: Dictionary = {
	CONSTANTS.SupportedGames.BOULDER_DASH : "res://Games/Supaplex/Board/board.tscn"
}
var GAME_TO_PARAM_SELECTION: Dictionary = {
	CONSTANTS.SupportedGames.BOULDER_DASH : "res://Games/Supaplex/UI/ParamSelection/supaplex_params_menu.tscn"
}

func getGameScene(game: CONSTANTS.SupportedGames):
	return GAME_TO_SCENE.get(game)

func getParamsSelectionMenu(game: CONSTANTS.SupportedGames):
	return GAME_TO_PARAM_SELECTION.get(game)
