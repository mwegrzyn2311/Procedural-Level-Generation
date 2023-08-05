extends Object

class_name TetrominoZone

# Dictionary[Vector2, bool] -> Represents which zone tiles are occupied
var zone_tiles: Dictionary
var tetrominos: Array[Tetromino]
var is_completed: bool

func _init(zone_tiles_positions: Array[Vector2]):
	self.zone_tiles = {}
	for pos in zone_tiles_positions:
		zone_tiles[pos] = false
	self.tetrominos = []
	self.is_completed = false
	
# Returns a tetromino ready to be placed or null if placement not possible
func can_place_tetromino(tetromino_type: TETROMINO_UTIL.Type) -> Tetromino:
	# Try place starting at every zone pos
	for zone_pos in zone_tiles:
		# If is not occupied
		if not zone_tiles[zone_pos]:
			# For every possible rotation
			for shape in TETROMINO_UTIL.rotated_shapes[tetromino_type]:
				var offset = shape[0] - zone_pos
				var fits = true
				for shape_pos in shape:
					var offseted_pos = shape_pos + offset
					if not offseted_pos in zone_tiles or zone_tiles[offseted_pos]:
						fits = false
						break
				if fits:
					return Tetromino.new(tetromino_type, shape.map(func(pos): return pos + offset))
	return null

func place_tetromino(tetromino: Tetromino):
	for pos in tetromino.tiles:
		zone_tiles[pos] = true
	if zone_tiles.values().filter(COLLECTION_UTIL.true_filter).is_empty():
		is_completed = true
