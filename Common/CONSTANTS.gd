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

const UNIT_VECTORS: Array[Vector2] = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]
const DIAGONAL_UNIT_VECTORS: Array[Vector2] = [Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]
