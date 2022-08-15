extends Spatial

onready var satellite = Global.satellite

func _process(_delta):
	if satellite != null:
		$Cylinder.look_at(satellite.translation, Vector3.UP)
		$Cylinder.rotation_degrees.y += 180
