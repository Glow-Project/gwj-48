extends Spatial

func _ready():
	$AnimationPlayer.play("start")

func _on_GameEndArea_body_entered(body):
	if body is KinematicBody:
		$BackgroundMusic.stop()
		$Player/AnimationPlayer.stop()
		$AnimationPlayer.play("end")
		yield($AnimationPlayer, "animation_finished")
		get_tree().quit()

func _on_Player_lost():
	$AnimationPlayer.play("death")
	var name = yield($AnimationPlayer, "animation_finished")
	# the animation could have changed to "won" because the player might
	# have been able to complete the game while the screen was fading to black
	if name == "death":
		get_tree().reload_current_scene()
