extends Object

class_name TetrominoZone

# Dictionary[Vector2, bool] -> Represents which zone tiles are occupied
var zone_tiles: Dictionary
var tetrominos: Array[Tetromino]
var is_completed: bool

func _init(zone_tiles: Dictionary, tetrominos: Array[Tetromino], is_completed: bool):
	self.zone_tiles = zone_tiles
	self.tetrominos = tetrominos
	self.is_completed = false
	
static func initial_state(zone_tiles_positions: Array[Vector2]):
	var zone_tiles: Dictionary = {}
	for pos in zone_tiles_positions:
		zone_tiles[pos] = false
	return TetrominoZone.new(zone_tiles, [], false)
	
func copy():
	# TODO: Investigate if this duplicate(true) is fine for tetrominos which are not going to be deep copied
	return TetrominoZone.new(zone_tiles.duplicate(true), tetrominos.duplicate(true), is_completed)
	
# Returns a tetromino ready to be placed or null if placement not possible
func can_place_tetromino(tetromino_type: TETROMINO_UTIL.Type) -> Tetromino:
	# Try place starting at every zone pos
	for zone_pos in zone_tiles:
		# If is not occupied
		if not zone_tiles[zone_pos]:
			# For every possible rotation
			for shape in TETROMINO_UTIL.rotated_shapes[tetromino_type]:
				if shape.size() > zone_tiles.size():
					return null
				var offset = zone_pos - shape[0] * 2
				var fits = true
				for shape_pos in shape:
					var offseted_pos = shape_pos * 2 + offset
					if offseted_pos not in zone_tiles or zone_tiles[offseted_pos]:
						fits = false
						break
				if fits:
					return Tetromino.new(tetromino_type, shape.map(func(pos: Vector2) -> Vector2: return pos * 2 + offset))
	return null

func place_tetromino(tetromino: Tetromino):
	for pos in tetromino.tiles:
		assert(pos in zone_tiles.keys(), "ERR: Trying to place tetromino in a zone on illegal pos")
		assert(not zone_tiles[pos], "ERR: Trying to place over occupied pos")
		zone_tiles[pos] = true
	self.tetrominos.append(tetromino)
	if zone_tiles.values().filter(COLLECTION_UTIL.false_filter).is_empty():
		is_completed = true
