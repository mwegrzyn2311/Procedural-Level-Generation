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
