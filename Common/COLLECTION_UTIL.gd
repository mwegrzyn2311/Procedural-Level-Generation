extends Node


func dict_get_or_default(dict: Dictionary, key, default):
	if dict.has(key):
		return dict[key]
	else:
		return default
