extends Node


const MAIN_MENU: String = "res://UI/Menu/main_menu.tscn"
const GAME_SELECTION: String = "res://UI/Menu/game_selection_menu.tscn"
var game_scene = null

var GAME_TO_SCENE: Dictionary = {
	CONSTANTS.SupportedGames.BOULDER_DASH : "res://Games/Supaplex/Board/board.tscn",
	CONSTANTS.SupportedGames.THE_WITNESS_PANELS : "res://Games/Panel/Board/board.tscn"
}
var GAME_TO_ALGO_TO_PARAM_SELECTION: Dictionary = {
	CONSTANTS.SupportedGames.BOULDER_DASH : {
		CONSTANTS.SupportedAlgos.TEMPLATE_BASED: "res://UI/GameUI/Supaplex/supaplex_template_based_params_menu.tscn",
		CONSTANTS.SupportedAlgos.MONTE_CARLO: "res://Games/Supaplex/UI/ParamSelection/supaplex_mcts_based_params_menu.tscn"
	},
	CONSTANTS.SupportedGames.THE_WITNESS_PANELS : {
		CONSTANTS.SupportedAlgos.TEMPLATE_BASED: "res://Games/Panel/UI/panel_template_based_params_menu.tscn",
		CONSTANTS.SupportedAlgos.MONTE_CARLO: "res://Games/Panel/UI/panel_mcts_based_params_menu.tscn"
	}
}
var GAME_TO_INFO_SCRIPT: Dictionary = {
	CONSTANTS.SupportedGames.BOULDER_DASH: CURRENT_LEVEL_INFO,
	CONSTANTS.SupportedGames.THE_WITNESS_PANELS: CURRENT_PANEL,
}

func getGameScene(game: CONSTANTS.SupportedGames) -> String:
	return GAME_TO_SCENE.get(game)

func getParamsSelectionMenu(game: CONSTANTS.SupportedGames, algo: CONSTANTS.SupportedAlgos) -> String:
	return GAME_TO_ALGO_TO_PARAM_SELECTION.get(game).get(algo)
