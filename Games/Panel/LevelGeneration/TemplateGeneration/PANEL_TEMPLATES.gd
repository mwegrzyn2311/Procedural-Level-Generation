extends Node


var EMPTY = PANEL_ELEMENTS.Ele.EMPTY
var INTERSECTION = PANEL_ELEMENTS.Ele.INTERSECTION
var PIPE = PANEL_ELEMENTS.Ele.PIPE

# TODO: The algorithm isn't prepared for this actually... Because neighbouring 3x3 sections would overlap
# Will either have to customize the logic or make those 2x2 and figure something out for the last column
var TEMPLATES_1: LevelTemplates = LevelTemplates.new(
	3,
	3,
	[
		{
			Vector2(0,0): INTERSECTION, Vector2(1,0): PIPE, Vector2(2,0): INTERSECTION,
			Vector2(0,1): PIPE, Vector2(1,1): EMPTY, Vector2(2,1): PIPE,
			Vector2(0,2): INTERSECTION, Vector2(1,2): PIPE, Vector2(2,2): INTERSECTION
		},
		{
			Vector2(0,0): INTERSECTION, Vector2(1,0): PIPE, Vector2(2,0): INTERSECTION,
			Vector2(0,1): PIPE, Vector2(1,1): EMPTY, Vector2(2,1): EMPTY,
			Vector2(0,2): INTERSECTION, Vector2(1,2): EMPTY, Vector2(2,2): EMPTY,
			
			Vector2(2,3): EMPTY, Vector2(3,2): EMPTY
		},
		{
			Vector2(0,0): INTERSECTION, Vector2(1,0): PIPE, Vector2(2,0): INTERSECTION,
			Vector2(0,1): EMPTY, Vector2(1,1): EMPTY, Vector2(2,1): EMPTY,
			Vector2(0,2): EMPTY, Vector2(1,2): EMPTY, Vector2(2,2): EMPTY,
			
			Vector2(-1,2): EMPTY, Vector2(0, 3): EMPTY,
			Vector2(2,3): EMPTY, Vector2(3,2): EMPTY
		},
		{
			Vector2(0,0): INTERSECTION, Vector2(1,0): EMPTY, Vector2(2,0): EMPTY,
			Vector2(0,1): EMPTY, Vector2(1,1): EMPTY, Vector2(2,1): EMPTY,
			Vector2(0,2): EMPTY, Vector2(1,2): EMPTY, Vector2(2,2): EMPTY,
			
			Vector2(2,-1): EMPTY, Vector2(3, 0): EMPTY,
			Vector2(-1,2): EMPTY, Vector2(0, 3): EMPTY,
			Vector2(2,3): EMPTY, Vector2(3,2): EMPTY
		},
		{
			Vector2(0,0): INTERSECTION, Vector2(1,0): EMPTY, Vector2(2,0): EMPTY,
			Vector2(0,1): EMPTY, Vector2(1,1): EMPTY, Vector2(2,1): EMPTY,
			Vector2(0,2): EMPTY, Vector2(1,2): EMPTY, Vector2(2,2): INTERSECTION,
			
			Vector2(2,-1): EMPTY, Vector2(3, 0): EMPTY,
			Vector2(-1,2): EMPTY, Vector2(0, 3): EMPTY
		},
		{
			Vector2(0,0): INTERSECTION, Vector2(1,0): EMPTY, Vector2(2,0): INTERSECTION,
			Vector2(0,1): EMPTY, Vector2(1,1): EMPTY, Vector2(2,1): EMPTY,
			Vector2(0,2): INTERSECTION, Vector2(1,2): EMPTY, Vector2(2,2): INTERSECTION
		},
		{
			Vector2(0,0): INTERSECTION, Vector2(1,0): PIPE, Vector2(2,0): INTERSECTION,
			Vector2(0,1): PIPE, Vector2(1,1): EMPTY, Vector2(2,1): EMPTY,
			Vector2(0,2): INTERSECTION, Vector2(1,2): EMPTY, Vector2(2,2): INTERSECTION
		},
		{
			Vector2(0,0): INTERSECTION, Vector2(1,0): PIPE, Vector2(2,0): INTERSECTION,
			Vector2(0,1): PIPE, Vector2(1,1): EMPTY, Vector2(2,1): EMPTY,
			Vector2(0,2): INTERSECTION, Vector2(1,2): PIPE, Vector2(2,2): INTERSECTION
		},
		{
			Vector2(0,0): INTERSECTION, Vector2(1,0): PIPE, Vector2(2,0): INTERSECTION,
			Vector2(0,1): EMPTY, Vector2(1,1): EMPTY, Vector2(2,1): EMPTY,
			Vector2(0,2): INTERSECTION, Vector2(1,2): EMPTY, Vector2(2,2): INTERSECTION
		},
		{
			Vector2(0,0): INTERSECTION, Vector2(1,0): PIPE, Vector2(2,0): INTERSECTION,
			Vector2(0,1): EMPTY, Vector2(1,1): EMPTY, Vector2(2,1): EMPTY,
			Vector2(0,2): INTERSECTION, Vector2(1,2): PIPE, Vector2(2,2): INTERSECTION
		},
	]
)
