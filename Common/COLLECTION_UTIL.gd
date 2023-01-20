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
