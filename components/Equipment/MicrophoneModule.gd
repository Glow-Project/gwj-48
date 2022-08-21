extends Spatial

signal picked_up()

var body_inside: bool

func _ready():
	$AnimationPlayer.play("default")
	$AudioStreamPlayer3D.play()

func _process(_delta):
	if body_inside and Input.is_action_just_pressed("ui_accept"):
		emit_signal("picked_up")
		Global.emit_signal("player_equipped_radio")
		queue_free()

func _on_Area_body_entered(body):
	if body is KinematicBody:
		body_inside = true
		$InstructionLabel.show()

func _on_Area_body_exited(body):
	if body is KinematicBody:
		body_inside = false
		$InstructionLabel.hide()
