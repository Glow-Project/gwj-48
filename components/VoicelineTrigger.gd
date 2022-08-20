tool
extends Area

signal triggered(voiceline)

export var radius: float = 1 setget set_radius
export var use_custom_collision_shape: bool = false setget set_custom_collision_usage
export var voiceline: AudioStream

func set_custom_collision_usage(value):
	use_custom_collision_shape = value
	$_CollisionShape.disabled = value
	$_CollisionShape.visible = not value

func set_radius(value):
	radius = value
	$_CollisionShape.shape.radius = radius

func _on_VoicelineTrigger_body_entered(body):
	if body is KinematicBody:
		emit_signal("triggered", voiceline)
		queue_free()
