extends Node


const MAIN_MENU: String = "res://UI/Menu/main_menu.tscn"
const GAME_SELECTION: String = "res://UI/Menu/game_selection_menu.tscn"

var GAME_TO_SCENE: Dictionary = {
	CONSTANTS.SupportedGames.BOULDER_DASH : "res://Games/Supaplex/Board/board.tscn"
}
var GAME_TO_ALGO_TO_PARAM_SELECTION: Dictionary = {
	CONSTANTS.SupportedGames.BOULDER_DASH : {
		CONSTANTS.SupportedAlgos.TEMPLATE_BASED: "res://UI/GameUI/Supaplex/supaplex_template_based_params_menu.tscn"
	}
}

# TODO: Will require algo once there is more than one
func getGameScene(game: CONSTANTS.SupportedGames) -> String:
	return GAME_TO_SCENE.get(game)

func getParamsSelectionMenu(game: CONSTANTS.SupportedGames, algo: CONSTANTS.SupportedAlgos) -> String:
	return GAME_TO_ALGO_TO_PARAM_SELECTION.get(game).get(algo)
