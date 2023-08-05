extends Object

class_name Tetromino

# Coordinates of nodes occupied by the tetromino
var type: TETROMINO_UTIL.Type
var tiles: Array[Vector2]

func _init(type: TETROMINO_UTIL.Type, tiles: Array[Vector2]):
	# TODO: Should also verify that the shape is the same
	assert(TETROMINO_UTIL.TypeToShape[type].size() == tiles.size(), "The no. of tiles passed to the tetromino doesn't match it's shape size")
	self.type = type
	self.tiles = tiles
