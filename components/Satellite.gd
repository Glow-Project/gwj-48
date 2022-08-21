extends Spatial

export var target_path: NodePath
export var speed: float = 3
export var op_map: bool = true

var center_radius: float
var angle: float = 0.0

onready var target: Spatial = get_node(target_path)

func _ready():
	Global.satellite = self
	center_radius = global_translation.distance_to(target.global_translation)
	if op_map: $Camera.look_at(target.global_translation, Vector3.UP)

func _exit_tree():
	Global.satellite = null

func _physics_process(delta):
	# rotate satellite in circle around target
	target.rotation_degrees.y -= speed * delta

