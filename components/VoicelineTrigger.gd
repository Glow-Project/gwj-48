tool
extends Area

signal triggered(voiceline)

export var radius: float = 1 setget set_radius
export var voiceline: AudioStream

func set_radius(value):
	radius = value
	$CollisionShape.shape.radius = radius

func _on_VoicelineTrigger_body_entered(body):
	if body is KinematicBody:
		emit_signal("triggered", voiceline)
		queue_free()
