extends Node2D

@onready var elements: Node2D = $Elements

func _ready():
	print(self.testing_elements_to_generation_array_string())

func testing_elements_to_generation_array_string() -> String:
	var res: String = "	return [\n"
	for container in self.elements.get_children():
		for element in container.get_children():
			res += "		%s,\n" % TILEMAP_UTILS.to_gen_str(element)
	res +="]"
	return res
