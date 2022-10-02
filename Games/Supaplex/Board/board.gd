extends Node2D

# TODO: Replace wall with non-destructible walls
var Wall = preload("res://Games/Supaplex/Elements/Wall/wall.tscn")

func _ready():
	self.generate_fence()
	self.generate_elements()

func generate_fence():
	for i in range(-1, CURRENT_LEVEL_INFO.width + 2):
		get_ele_with_coords(Wall, Vector2(i, -1)).add_to_group("fence")
		get_ele_with_coords(Wall, Vector2(i, CURRENT_LEVEL_INFO.height + 1)).add_to_group("fence")
		#self.add_child(get_ele_with_coords(Wall, Vector2(i, -1)))
		#self.add_child(get_ele_with_coords(Wall, Vector2(i, CURRENT_LEVEL_INFO.height + 1)))
	
	
	for j in range(0, CURRENT_LEVEL_INFO.height + 1):
		self.add_child(get_ele_with_coords(Wall, Vector2(-1, j)))
		self.add_child(get_ele_with_coords(Wall, Vector2(CURRENT_LEVEL_INFO.width + 1, j)))

# TODO: Extract to Singleton util
func get_ele_with_coords(packed_scene: PackedScene, coords: Vector2):
	var ele = packed_scene.instantiate()
	ele.set_coords(coords)
	return ele

func generate_elements():
	for element in CURRENT_LEVEL_INFO.level_map:
		self.add_child(element)
		element.add_to_group("game_elements")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
