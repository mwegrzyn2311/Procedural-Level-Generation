extends Object

class_name Tetromino

# Coordinates of nodes occupied by the tetromino
var type: TETROMINO_UTIL.Type
# Array[Vector2]
var tiles: Array
var pos: Vector2

# tiles: Array[Vector2]
func _init(type: TETROMINO_UTIL.Type, tiles: Array):
	# TODO: Should also verify that the shape is the same
	assert(TETROMINO_UTIL.TypeToShape[type].size() == tiles.size(), "The no. of tiles passed to the tetromino doesn't match it's shape size")
	self.type = type
	self.tiles = tiles
	# TODO: This could further improve difficulty of generated levels if this was smart instead of just random
	# Assign random position as the position of the tetromino
	self.pos = RNG_UTIL.choice(tiles)
