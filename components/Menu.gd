extends Control

onready var volume_slider: Slider = $"%Volume"
onready var mouse_slider: Slider = $"%MouseSensitivity"

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		visible = not visible
		get_tree().paused = not get_tree().paused
		
		if visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$AnimationPlayer.play("Pause")
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			$AnimationPlayer.play("Continue")
		
		# update volume slider
		volume_slider.value = db2linear(AudioServer.get_bus_volume_db(0))

func _on_Volume_drag_ended(value_changed):
	AudioServer.set_bus_volume_db(0, linear2db(volume_slider.value))
	if not $VolumeTest.playing:
		$VolumeTest.play()

func _on_Continue_pressed():
	hide()
	get_tree().paused = false

func _on_Exit_pressed():
	get_tree().quit()
