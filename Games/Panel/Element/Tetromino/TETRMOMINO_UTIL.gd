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

var rotations: Array[Vector2] = [Vector2(-1, 1), Vector2(-1, -1), Vector2(1, -1)]
# Dictionary[Type, Array[Array[Vector2]]] - We have it here in the singleton so that it is generated once in order to optimize
var rotated_shapes: Dictionary = {}
var types_arr: Array[Type] = []

func _init():
	for type in TypeToShape:
		# Array[Array[Vector2]]
		var shapes: Array[Array] = [TypeToShape[type]]
		for rotation in rotations:
			# Array[Vector2]
			var rotated_shape: Array = TypeToShape[type].map(func(pos) -> Vector2: return pos * rotation)
			if not _contains_shape(shapes, rotated_shape):
				shapes.append(rotated_shape)
		rotated_shapes[type] = shapes
	for type in Type:
		types_arr.append(type)

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
