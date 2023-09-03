extends TemplateLevelGenerator
class_name SupaplexTemplateLevelGeneratorV2

# This class is responsile for generating levels from 3x3 tile templates

const ROCK_CHANCE_MULT: float = 0.2
const EMPTY_CHANCE_MULT: float = 0.6
const DEPTH_MODIF: float = 0.0
const WIDTH_MODIF: float = 1.0
var MAKE_EMPTY_NEIGH_TO_CHANCE: Dictionary = {
	TILE_ELEMENTS.Ele.GRASS: 0.2,
	TILE_ELEMENTS.Ele.BOULDER: 0.5
}

func _init(width: int, height: int, level_templates: LevelTemplates):
	super(width, height, level_templates)

# TODO: I think that with some templates it's possible to get an occurence that no template would fit which leads to inifite loop
# TODO: It'd also be good to not pick the same template with the same rotation twice but with so many choices it might consume some memory and maybe even time...
func generate_level() -> Dictionary:
	var res: Dictionary = {}
	var i = 0
	while res.is_empty() or not SUPAPLEX_UTILS.is_one_open_region(res):
		res = super.generate_level()
		i += 1
	print("generated open region after " + str(i) + " tries")
	# Place_exit 100% randomly
	res = place_exit(res)
	# Move randomly - TODO: Moves or sequences?

	return res
	
func place_exit(res: Dictionary) -> Dictionary:
	var rand_grass_pos: Vector2 =  RNG_UTIL.choice(res.keys().filter(func(pos): res[pos] == TILE_ELEMENTS.Ele.GRASS))
	res[rand_grass_pos] = TILE_ELEMENTS.Ele.EXIT
	return res

