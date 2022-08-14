extends Spatial

export var target_path: NodePath
export var speed: float = 0.1

var center_radius: float
var angle: float = 0.0

onready var target: Spatial = get_node(target_path)

func _ready():
	center_radius = global_translation.distance_to(target.global_translation)

func _physics_process(delta):
	var pos = global_translation
	var point = target.global_translation
	angle += delta * speed
	global_translation = point + (pos - point).rotated(point.normalized(), delta * speed)

	$Camera.look_at(target.global_translation, Vector3.UP)
	look_at(Vector3(point.x, pos.y, point.z), Vector3.UP)
	rotation.y += 90
