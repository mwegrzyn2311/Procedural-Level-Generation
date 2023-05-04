extends Node

const PIPE_LEN = 5
const ELE_SIZE = 256
const ELE_SCALE = 0.125

enum Ele {
	START,
	INTERSECTION,
	PIPE,
	END,
	EMPTY
}

# This should be done with preload instead of class_name and being forced to 
# use SCENE const afterwards but there is a bug which breaks the scenes if
# preload is used in this class
var ELE_TO_SCENE: Dictionary = {
	Ele.START: PanelStart,
	Ele.INTERSECTION: PanelIntersection,
	Ele.PIPE: PanelPipe,
}
