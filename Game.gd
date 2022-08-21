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
