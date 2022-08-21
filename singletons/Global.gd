extends Node

signal player_equipped_radio()

var satellite: Spatial = null

func _init():
	# keep calling _process when paused
	pause_mode = Node.PAUSE_MODE_PROCESS

func _process(_delta):
	if Input.is_action_just_pressed("fullscreen_toggle"):
		OS.window_fullscreen = not OS.window_fullscreen
