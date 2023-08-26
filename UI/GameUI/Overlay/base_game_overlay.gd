extends Control

class_name BaseGameOverlay

@onready var completion_overlay = $LevelCompletedOverlay

func _ready():
	NAVIGATION.register_game_overlay(self)

func enable_completion_overlay_visibility():
	if completion_overlay.visible:
		return
	completion_overlay.visible = true
	completion_overlay.mouse_filter = MOUSE_FILTER_IGNORE

func disable_completion_overlay_visibility():
	if not completion_overlay.visible:
		return
	completion_overlay.visible = false
	completion_overlay.mouse_filter = MOUSE_FILTER_STOP
