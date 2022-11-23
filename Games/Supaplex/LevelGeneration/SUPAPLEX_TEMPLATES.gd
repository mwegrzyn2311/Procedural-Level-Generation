extends Node

const WALL = "wall"
const GRASS = "grass"

# Consider Array[Dictionary[Vector2,String]] as well for templates
# TODO: Add templates with forcing neighbours (and add handling for them)
var TEMPLATES_1: LevelTemplates = LevelTemplates.new(
	3,
	3,
[
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): WALL,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): WALL,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
	},
])

var TEMPLATES_2: LevelTemplates = LevelTemplates.new(
	3,
	3,
[
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): WALL,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
	},
])

var TEMPLATES_3: LevelTemplates = LevelTemplates.new(
	3,
	3,
[
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): WALL,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(-1, 1): GRASS, Vector2(1, 3): GRASS,
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(-1, 0): GRASS, Vector2(3, 0): GRASS, Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(1, 3): GRASS,
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(-1, 1): GRASS, Vector2(3, 2): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(3, 0): GRASS, Vector2(1, 3): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(1, 3): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(-1, 1): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(-1, 1): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS, Vector2(1, 3): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS, Vector2(1, -1): GRASS, Vector2(1, 3): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(1, 3): GRASS,
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(-1, 0): GRASS, Vector2(0, 3): GRASS, Vector2(3, 1): GRASS,
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(0, 3): GRASS, Vector2(-1, 0): GRASS, Vector2(2, 3): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(3, 0): GRASS, Vector2(3, 2): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(1, 3): GRASS, Vector2(3, 1): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(1, 3): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): WALL,
		
		Vector2(3, 1): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(2, 3): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(1, -1): GRASS, Vector2(2, 3): GRASS,
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(0, -1): GRASS, Vector2(2, 3): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(-1, 1): GRASS,
	},
])

# TODO: Delete this one
var TEMPLATES_4_INCOMPLETE: LevelTemplates = LevelTemplates.new(
	3,
	3,
[
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): WALL,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3) : GRASS, Vector2(1, 3) : GRASS, Vector2(2, 3) : GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3) : GRASS, Vector2(1, 3) : GRASS, Vector2(2, 3) : GRASS
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(0, -1) : GRASS, Vector2(1, -1) : GRASS, Vector2(2, -1) : GRASS,
		Vector2(-1, 0): GRASS, Vector2(3, 0): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3) : GRASS, Vector2(1, 3) : GRASS, Vector2(2, 3) : GRASS
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		
		Vector2(0, -1) : GRASS, Vector2(1, -1) : GRASS, Vector2(2, -1) : GRASS,
		Vector2(-1, 0): GRASS, Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3) : GRASS, Vector2(1, 3) : GRASS, Vector2(2, 3) : GRASS,
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(0, -1) : GRASS, Vector2(1, -1) : GRASS, Vector2(2, -1) : GRASS,
		Vector2(-1, 0): GRASS, Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3) : GRASS, Vector2(1, 3) : GRASS, Vector2(2, 3) : GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(1, -1) : GRASS, Vector2(2, -1) : GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3) : GRASS, Vector2(1, 3) : GRASS, Vector2(2, 3) : GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(1, -1) : GRASS, Vector2(2, -1) : GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS,
		Vector2(0, 3) : GRASS, Vector2(1, 3) : GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(1, -1) : GRASS, Vector2(2, -1) : GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(3, 2): GRASS,
		Vector2(1, 3) : GRASS, Vector2(2, 3) : GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(1, -1) : GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(3, 2): GRASS,
		Vector2(1, 3) : GRASS, Vector2(2, 3) : GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(1, -1) : GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(1, 3) : GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(1, -1) : GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(1, 3) : GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(1, -1) : GRASS, Vector2(2, -1) : GRASS,
		Vector2(3, 0): GRASS,
		Vector2(3, 1): GRASS,
		Vector2(3, 2): GRASS,
		Vector2(1, 3) : GRASS, Vector2(2, 3) : GRASS
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(0, -1) : GRASS, Vector2(2, -1) : GRASS,
		Vector2(-1, 0): GRASS, Vector2(3, 0): GRASS,
		Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3) : GRASS, Vector2(2, 3) : GRASS
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(0, -1) : GRASS, Vector2(1, -1): GRASS, Vector2(2, -1) : GRASS,
		Vector2(-1, 0): GRASS, Vector2(3, 0): GRASS,
		Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3) : GRASS, Vector2(2, 3) : GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(1, -1): GRASS, Vector2(2, -1) : GRASS,
		Vector2(3, 0): GRASS,
		Vector2(3, 2): GRASS,
		Vector2(1, 3) : GRASS, Vector2(2, 3) : GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(3, 1): GRASS,
		Vector2(1, 3) : GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(3, 1): GRASS,
		Vector2(3, 2): GRASS,
		Vector2(1, 3) : GRASS, Vector2(2, 3) : GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): WALL,
		
		Vector2(3, 1): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(3, 1): GRASS,
		Vector2(3, 2): GRASS,
		Vector2(2, 3): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(1, -1): GRASS,
		Vector2(3, 1): GRASS,
		Vector2(3, 2): GRASS,
		Vector2(2, 3): GRASS,
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(0, -1): GRASS,
		Vector2(-1, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(3, 2): GRASS,
		Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(3, 2): GRASS,
		Vector2(2, 3): GRASS
	},
])

var TEMPLATES_5: LevelTemplates = LevelTemplates.new(
	3,
	3,
[
	# 9 walls
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): WALL,
	},
	# 8 walls
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(3, 2): GRASS,
		Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(1, 3): GRASS
	},
	# 7 walls
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(3, 2): GRASS,
		Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): WALL,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(1, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(3, 1): GRASS,
		Vector2(1, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(1, -1): GRASS,
		Vector2(1, 3): GRASS
	},
	# 6 walls
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(3, 1): GRASS,
		Vector2(3, 2): GRASS,
		Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): WALL,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(3, 2): GRASS,
		Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): WALL,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(1, -1): GRASS,
		Vector2(1, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(3, 1): GRASS,
		Vector2(1, 3): GRASS
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(0, -1): GRASS,
		Vector2(-1, 0): GRASS,
		Vector2(3, 1): GRASS,
		Vector2(1, 3): GRASS
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(0, -1): GRASS,
		Vector2(-1, 0): GRASS,
		Vector2(3, 2): GRASS,
		Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): WALL,
		
		Vector2(0, -1): GRASS,
		Vector2(-1, 0): GRASS,
		Vector2(3, 1): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(-1, 1): GRASS,
		Vector2(3, 2): GRASS,
		Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	# 5 walls
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(1, -1): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(1, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(-1, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(-1, 1): GRASS,
		Vector2(-1, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(-1, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(2, 3): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): WALL, Vector2(2, 2): WALL,
		
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS,
		Vector2(0, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(1, 3): GRASS
	},
	# 4 walls
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(3, 2): GRASS,
		Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(3, 2): GRASS,
		Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(3, 2): GRASS,
		Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): WALL, Vector2(2, 2): WALL,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS,
		Vector2(0, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(3, 2): GRASS,
		Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS,
		Vector2(-1, 2): GRASS,Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(1, -1): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(1, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(1, -1): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(3, 2): GRASS,
		Vector2(1, 3): GRASS, Vector2(2, 3): GRASS,
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(1, -1): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(1, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(3, 2): GRASS,
		Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(1, -1): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(1, -1): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(3, 2): GRASS,
		Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(1, -1): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(0, -1): GRASS, Vector2(1, -1): GRASS,
		Vector2(-1, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(3, 2): GRASS,
		Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(0, -1): GRASS, Vector2(2, -1): GRASS,
		Vector2(-1, 0): GRASS, Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(3, 2): GRASS,
		Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(0, -1): GRASS, Vector2(2, -1): GRASS,
		Vector2(-1, 0): GRASS, Vector2(3, 0): GRASS,
		Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	# 2 walls
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(1, -1): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(1, -1): GRASS, Vector2(2, -1): GRASS,
		Vector2(-1, 0): GRASS, Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(1, -1): GRASS, Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): WALL,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(0, -1): GRASS, Vector2(1, -1): GRASS, Vector2(2, -1): GRASS,
		Vector2(-1, 0): GRASS, Vector2(3, 0): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): WALL, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(0, -1): GRASS, Vector2(2, -1): GRASS,
		Vector2(-1, 0): GRASS, Vector2(3, 0): GRASS,
		Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(0, -1): GRASS, Vector2(1, -1): GRASS,
		Vector2(-1, 0): GRASS,
		Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	# 1 wall
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): WALL, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(0, -1): GRASS, Vector2(1, -1): GRASS, Vector2(2, -1): GRASS,
		Vector2(-1, 0): GRASS, Vector2(3, 0): GRASS,
		Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(1, -1): GRASS, Vector2(2, -1): GRASS,
		Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): WALL, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
		
		Vector2(0, -1): GRASS, Vector2(1, -1): GRASS, Vector2(2, -1): GRASS,
		Vector2(-1, 0): GRASS, Vector2(3, 0): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(1, 3): GRASS, Vector2(2, 3): GRASS
	},
])
