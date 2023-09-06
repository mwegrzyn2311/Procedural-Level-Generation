extends Node

const PIPE_LEN = 2
const ELE_SIZE = 256
const ELE_SCALE = 0.125
const TETROMINO_SQUARE_FRACTION = 0.25
const TETROMINO_SQUARE_SIZE = ELE_SIZE * PIPE_LEN * TETROMINO_SQUARE_FRACTION
const HALF_PIPE_OFFSET = ((PANEL_ELEMENTS.PIPE_LEN - 1) * PANEL_ELEMENTS.ELE_SIZE * PANEL_ELEMENTS.ELE_SCALE) / 2

enum Ele {
	START,
	INTERSECTION,
	PIPE,
	FINISH,
	EMPTY,
	TETROMINO,
	LINE
}

# This should be done with preload instead of class_name and being forced to 
# use SCENE const afterwards but there is a bug which breaks the scenes if
# preload is used in this class
var ELE_TO_SCENE: Dictionary = {
	Ele.START: PanelStart,
	Ele.INTERSECTION: PanelIntersection,
	Ele.PIPE: PanelPipe,
	Ele.FINISH: PanelFinish,
	Ele.TETROMINO: TetrominoEle,
	Ele.LINE: DebugLine
}
