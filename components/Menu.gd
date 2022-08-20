extends Control

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		visible = not visible
		get_tree().paused = not get_tree().paused

func _on_Volume_drag_ended(value_changed):
	AudioServer.set_bus_volume_db(0, linear2db($Volume.value))

func _on_Button_pressed():
	get_tree().quit()

func _on_Continue_pressed():
	hide()
	get_tree().paused = false
