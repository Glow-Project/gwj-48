extends Control


func _ready():
	$AnimationPlayer.play("start")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://Game.tscn")
