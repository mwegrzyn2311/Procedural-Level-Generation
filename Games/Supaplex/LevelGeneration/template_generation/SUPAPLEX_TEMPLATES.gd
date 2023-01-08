extends Node

const WALL = "wall"
const GRASS = "grass"

# Consider Array[Dictionary[Vector2,String]] as well for templates

var TEMPLATES_6: LevelTemplates = LevelTemplates.new(
	3,
	3,
[
	# 9 walls
	{
		Vector2(0, 0): WALL, Vector2(1, 0): WALL, Vector2(2, 0): WALL,
		Vector2(0, 1): WALL, Vector2(1, 1): WALL, Vector2(2, 1): WALL,
		Vector2(0, 2): WALL, Vector2(1, 2): WALL, Vector2(2, 2): WALL,
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
	# 5 walls
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
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): WALL, Vector2(2, 2): GRASS,
		
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(-1, 2): GRASS, Vector2(3, 2): GRASS,
		Vector2(0, 3): GRASS, Vector2(2, 3): GRASS
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
		Vector2(0, 0): WALL, Vector2(1, 0): GRASS, Vector2(2, 0): WALL,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): WALL, Vector2(1, 2): GRASS, Vector2(2, 2): WALL,
		
		Vector2(1, -1): GRASS,
		Vector2(-1, 1): GRASS, Vector2(3, 1): GRASS,
		Vector2(1, 3): GRASS
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
	# 3 walls
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
	# 0 walls
	{
		Vector2(0, 0): GRASS, Vector2(1, 0): GRASS, Vector2(2, 0): GRASS,
		Vector2(0, 1): GRASS, Vector2(1, 1): GRASS, Vector2(2, 1): GRASS,
		Vector2(0, 2): GRASS, Vector2(1, 2): GRASS, Vector2(2, 2): GRASS,
	},
])
