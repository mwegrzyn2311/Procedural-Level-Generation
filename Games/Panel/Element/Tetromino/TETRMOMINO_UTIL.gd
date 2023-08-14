extends Node

enum Type {
	ONE_BY_ONE,   # 1x1 square
	ONE_BY_TWO,   # 1x2 rect
	ONE_BY_TRHEE, # 1x3 rect
	ONE_BY_FOUR,  # 1x4 rect
	CORNER,       # L consisting of 3 elements
	TWO_BY_TWO,   # 2x2 square
	L,            # L consisting of 4 elements (3 in one dir and 2 in the other)
	J,            # L but flipped
	T,            # T consising of 4 elements
	S,            # Imagine 1256 on numeric keyboard
	Z,            # Imagine 4523 on numeric keyboard
	PLUS,         # Plus sign consisting of 5 elements
}

# Dictionary[]
const TypeToShape: Dictionary = {
	Type.ONE_BY_ONE:   [Vector2(0,0)],
	Type.ONE_BY_TWO:   [Vector2(0,0), Vector2(1,0)],
	Type.ONE_BY_TRHEE: [Vector2(0,0), Vector2(1,0), Vector2(2,0)],
	Type.ONE_BY_FOUR:  [Vector2(0,0), Vector2(1,0), Vector2(2,0), Vector2(3,0)],
	Type.CORNER:       [Vector2(0,0), Vector2(1,0), Vector2(1,1)],
	Type.TWO_BY_TWO:   [Vector2(0,0), Vector2(1,0), Vector2(0,1), Vector2(1,1)],
	Type.L:            [Vector2(0,0), Vector2(0,1), Vector2(0,2), Vector2(1,2)],
	Type.J:            [Vector2(0,0), Vector2(1,0), Vector2(2,0), Vector2(2,1)],
	Type.T:            [Vector2(0,0), Vector2(1,0), Vector2(2,0), Vector2(1,1)],
	Type.S:            [Vector2(0,0), Vector2(0,1), Vector2(1,1), Vector2(1,2)],
	Type.Z:            [Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(2,1)],
	Type.PLUS:         [Vector2(1,0), Vector2(0,1), Vector2(1,1), Vector2(1,2), Vector2(2,1)]
}

const ELE_CENTER: Vector2 = Vector2(PANEL_ELEMENTS.ELE_SIZE * PANEL_ELEMENTS.PIPE_LEN / 2, PANEL_ELEMENTS.ELE_SIZE * PANEL_ELEMENTS.PIPE_LEN / 2)

var rotations: Array[Vector2] = [Vector2(-1, 1), Vector2(-1, -1), Vector2(1, -1)]
# Dictionary[Type, Array[Array[Vector2]]] - We have it here in the singleton so that it is generated once in order to optimize
var rotated_shapes: Dictionary = {}
var types_arr: Array[Type]
# Dictionary[Type, Node2D(Composed of a few sprites)]
var tetromino_sprites: Dictionary = {}

func _init():
	_generate_rotated_shapes()
	_genereate_types_arr()
	_generate_tetromino_sprites()

func _generate_rotated_shapes():
	for type in TypeToShape:
		# Array[Array[Vector2]]
		var shapes: Array[Array] = [TypeToShape[type]]
		for rotation in rotations:
			# Array[Vector2]
			var rotated_shape: Array = TypeToShape[type].map(func(pos) -> Vector2: return pos * rotation)
			if not _contains_shape(shapes, rotated_shape):
				shapes.append(rotated_shape)
		rotated_shapes[type] = shapes

static func _contains_shape(shapes: Array[Array], shape: Array) -> bool:
	for existing_shape in shapes:
		var duplicated_ex_shape: Array = existing_shape.duplicate()
		var left_top_ex = _left_top(duplicated_ex_shape)
		for pos in shape:
			var left_top_shape = _left_top(shape)
			var offset = left_top_shape - left_top_ex
			duplicated_ex_shape.erase(pos - offset)
		if duplicated_ex_shape.is_empty():
			return true
	return false

static func _left_top(shape: Array):
	return Vector2(shape.map(func(pos) -> int: return pos.x).min(), shape.map(func(pos) -> int: return pos.y).min())

static func _right_bottom(shape: Array):
	return Vector2(shape.map(func(pos) -> int: return pos.x).max(), shape.map(func(pos) -> int: return pos.y).max()) + Vector2.ONE

func _genereate_types_arr():
	types_arr = []
	for type in Type.values():
		types_arr.append(type)
	types_arr.erase(Type.ONE_BY_ONE)

func _generate_tetromino_sprites():
	for type in TypeToShape:
		_generate_tetromino_sprite(type)

func _generate_tetromino_sprite(type: Type):
	var shape = TypeToShape[type]
	var left_top: Vector2 = _left_top(shape)
	var right_bottom: Vector2 = _right_bottom(shape)
	var offset: Vector2 = (right_bottom - left_top) * PANEL_ELEMENTS.TETROMINO_SQUARE_SIZE / 2
	var node: Node2D = Node2D.new()
	for ele in shape:
		var sprite = Sprite2D.new()
		sprite.texture = load("res://Games/Panel/Element/Tetromino/square_64_with_frame.png")
		sprite.scale = Vector2(PANEL_ELEMENTS.PIPE_LEN, PANEL_ELEMENTS.PIPE_LEN)
		node.add_child(sprite)
		var pos = ELE_CENTER - offset + ele * PANEL_ELEMENTS.TETROMINO_SQUARE_SIZE
		sprite.position = pos
	tetromino_sprites[type] = node
