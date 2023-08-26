extends Node


func dict_get_or_default(dict: Dictionary, key, default):
	if dict.has(key):
		return dict[key]
	else:
		return default

func sum(arr: Array):
	if arr.is_empty():
		return 0
	var res = arr[0]
	for i in range(1, arr.size()):
		res += arr[i]
	return res

func get_dict_dims(dict: Dictionary) -> Vector2:
	var res = Vector2(0, 0)
	for pos in dict:
		if pos.x > res.x:
			res.x = pos.x
		if pos.y > res.y:
			res.y = pos.y
	return res + Vector2.ONE

func nice_print_dict(dict: Dictionary):
	var dims: Vector2 = get_dict_dims(dict)
	for y in range(dims.y):
		var row = ""
		for x in range(dims.x):
			var pos = Vector2(x, y)
			if dict.has(pos):
				row += str(dict[pos])
			else:
				row += " "
		print(row)

func true_filter(val: bool):
	return val == true

func false_filter(val: bool):
	return val == false
	
static func max_custom(arr: Array, val_func: Callable):
	if arr.size() == 0:
		return null
	var val_max = val_func.call(arr[0])
	var idx_max = 0
	for i in range(1, arr.size()):
		var val = val_func.call(arr[i])
		if val > val_max:
			val_max = val
			idx_max = i
	return arr[idx_max]

static func min_custom(arr: Array, val_func: Callable):
	if arr.size() == 0:
		return null
	var val_min = val_func.call(arr[0])
	var idx_min = 0
	for i in range(1, arr.size()):
		var val = val_func.call(arr[i])
		if val < val_min:
			val_min = val
			idx_min = i
	return arr[idx_min]
	
static func num_sum(a, b):
	return a + b
	
static func sets_eq(a: Array, b: Array) -> bool:
	if a.size() != b.size():
		return false
	var remaining = a.duplicate(true)
	for el in b:
		if (el is Array and deep_has(remaining, el)) or (not el is Array and el not in remaining):
			return false
		remaining.erase(el)
	return true

# func(Array[Array], Array)
static func deep_has(a, b) -> bool:
	for arr in a:
		if sets_eq(arr, b):
			return true
	return false
