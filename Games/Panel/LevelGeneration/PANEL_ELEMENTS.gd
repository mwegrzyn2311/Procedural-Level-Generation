extends Node

const PIPE_LEN = 3
const ELE_SIZE = 256
const ELE_SCALE = 0.1

enum Ele {
	START,
	INTERSECTION,
	PIPE,
	FINISH,
	EMPTY
}

# This should be done with preload instead of class_name and being forced to 
# use SCENE const afterwards but there is a bug which breaks the scenes if
# preload is used in this class
var ELE_TO_SCENE: Dictionary = {
	Ele.START: PanelStart,
	Ele.INTERSECTION: PanelIntersection,
	Ele.PIPE: PanelPipe,
	Ele.FINISH: PanelFinish
}
