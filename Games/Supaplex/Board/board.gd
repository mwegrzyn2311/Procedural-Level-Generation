extends Node2D

@onready var fence: Node2D = $Fence
@onready var game_elements: Node2D = $GameElements

func _ready():
	self.generate_fence()
	self.generate_elements()

func generate_fence():
	for i in range(-1, CURRENT_LEVEL_INFO.width + 2):
		fence.add_child(TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.OBELISK, Vector2(i, -1)))
		fence.add_child(TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.OBELISK, Vector2(i, CURRENT_LEVEL_INFO.height + 1)))
	
	
	for j in range(0, CURRENT_LEVEL_INFO.height + 1):
		fence.add_child(TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.OBELISK, Vector2(-1, j)))
		fence.add_child(TILEMAP_UTILS.ele_instance(TILE_ELEMENTS.OBELISK, Vector2(CURRENT_LEVEL_INFO.width + 1, j)))

func generate_elements():
	for element in CURRENT_LEVEL_INFO.level_map:
		game_elements.add_child(element)
		element.add_to_group("game_elements")

# TODO: Remove this debug function
#var counter: int = 0
#
#func _process(delta):
#	counter += 1
#	if counter > 333:
#		counter = 0
#		var children = game_elements.get_children()
#		for child in children:
#			print(child.position)
