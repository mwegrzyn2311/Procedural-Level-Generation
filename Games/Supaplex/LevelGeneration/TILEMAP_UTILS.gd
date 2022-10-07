extends Node

const ele_gen_str_format = "TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.%s, Vector2%s)"
var regex = RegEx.new()

func _ready():
	regex.compile("\\d+")

func ele_instance(packed_scene: PackedScene, coords: Vector2):
	var ele = packed_scene.instantiate()
	ele.set_coords(coords)
	return ele

func to_gen_str(ele):
	return ele_gen_str_format % [ele_base_name(String(ele.get_name())).to_upper(), str(ele.position/CONSTANTS.TILE_SIZE)]

func ele_base_name(ele_name: String):
	return regex.sub(ele_name, "")
