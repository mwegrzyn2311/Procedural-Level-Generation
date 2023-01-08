extends Node


enum SupportedGames {
	BOULDER_DASH,
	THE_WITNESS_PANELS
}

enum SupportedAlgos {
	TEMPLATE_BASED,
	MONTE_CARLO
}

var ALGOS_PER_GAME: Dictionary = {
	SupportedGames.BOULDER_DASH: [SupportedAlgos.TEMPLATE_BASED, SupportedAlgos.MONTE_CARLO],
	SupportedGames.THE_WITNESS_PANELS: [SupportedAlgos.TEMPLATE_BASED]
}
