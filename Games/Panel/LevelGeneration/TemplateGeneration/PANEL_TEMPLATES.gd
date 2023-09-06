extends Node


var EMPTY = PANEL_ELEMENTS.Ele.EMPTY
var INTERSECTION = PANEL_ELEMENTS.Ele.INTERSECTION
var PIPE = PANEL_ELEMENTS.Ele.PIPE
var LINE = PANEL_ELEMENTS.Ele.LINE
var START = PANEL_ELEMENTS.Ele.START

# TODO: The algorithm isn't prepared for this actually... Because neighbouring 3x3 sections would overlap
# Will either have to customize the logic or make those 2x2 and figure something out for the last column
var TEMPLATES_1: LevelTemplates = LevelTemplates.new(
	2,
	2,
	[
		{
			Vector2(0,0): INTERSECTION, Vector2(1,0): PIPE,
			Vector2(0,1): PIPE, Vector2(1,1): EMPTY
		},
		{
			Vector2(0,0): LINE, Vector2(1,0): LINE, Vector2(2,0): LINE,
			Vector2(0,1): PIPE, Vector2(1,1): EMPTY
		},
		{
			Vector2(0,0): LINE, Vector2(1,0): PIPE,
			Vector2(0,1): LINE, Vector2(1,1): EMPTY,
			Vector2(0,2):LINE
		}
	],
	{},
	false,
	[Vector2.ZERO, Vector2.ONE]
)
var TEMPLATES_3: LevelTemplates = LevelTemplates.new(
	2,
	2,
	[
		{
			Vector2(0,0): INTERSECTION, Vector2(1,0): PIPE,
			Vector2(0,1): PIPE, Vector2(1,1): EMPTY
		},
		{
			Vector2(0,0): INTERSECTION, Vector2(1,0): EMPTY,
			Vector2(0,1): PIPE, Vector2(1,1): EMPTY,
		},
		{
			Vector2(0,0): INTERSECTION, Vector2(1,0): PIPE,
			Vector2(0,1): EMPTY, Vector2(1,1): EMPTY,
		},
		{
			Vector2(0,0): LINE, Vector2(1,0): LINE, Vector2(2,0): LINE,
			Vector2(0,1): PIPE, Vector2(1,1): EMPTY
		},
		{
			Vector2(0,0): LINE, Vector2(1,0): PIPE,
			Vector2(0,1): LINE, Vector2(1,1): EMPTY,
			Vector2(0,2):LINE
		},
		{
			Vector2(0,0): LINE, Vector2(1,0): EMPTY,
			Vector2(0,1): LINE, Vector2(1,1): EMPTY,
			Vector2(0,2): LINE
		},
		{
			Vector2(0,0): LINE, Vector2(1,0): LINE, Vector2(2,0): LINE,
			Vector2(0,1): EMPTY, Vector2(1,1): EMPTY,
		}
	],
	{},
	false,
	[Vector2.ZERO, Vector2.ONE]
)

var START_TEMPLATES_1: LevelTemplates = LevelTemplates.new(
	2,
	2,
	[
		{
			Vector2(0,0): START, Vector2(1,0): LINE, Vector2(2,0): LINE,
			Vector2(0,1): PIPE, Vector2(1,1): EMPTY
		},
		{
			Vector2(0,0): START, Vector2(1,0): PIPE,
			Vector2(0,1): LINE, Vector2(1,1): EMPTY,
			Vector2(0,2): LINE
		},
	],
	{},
	false,
	[Vector2.ZERO, Vector2.ONE]
)

var START_TEMPLATES_2: LevelTemplates = LevelTemplates.new(
	2,
	2,
	[
		{
			Vector2(0,0): START, Vector2(1,0): LINE, Vector2(2,0): LINE,
			Vector2(0,1): PIPE, Vector2(1,1): EMPTY
		},
		{
			Vector2(0,0): START, Vector2(1,0): LINE, Vector2(2,0): LINE,
			Vector2(0,1): EMPTY, Vector2(1,1): EMPTY,
		},
		{
			Vector2(0,0): START, Vector2(1,0): PIPE,
			Vector2(0,1): LINE, Vector2(1,1): EMPTY,
			Vector2(0,2): LINE
		},
		{
			Vector2(0,0): START, Vector2(1,0): EMPTY,
			Vector2(0,1): LINE, Vector2(1,1): EMPTY,
			Vector2(0,2): LINE
		}
	],
	{},
	false,
	[Vector2.ZERO, Vector2.ONE]
)
