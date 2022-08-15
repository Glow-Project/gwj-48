extends Node

var satellite: Spatial = null

func _process(_delta):
	if Input.is_action_just_pressed("fullscreen_toggle"):
		OS.window_fullscreen = not OS.window_fullscreen
