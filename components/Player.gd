extends KinematicBody

export var speed: float = 5
export var sensitivity: float = 0.005
export var camera_viewport_path: NodePath

var velocity := Vector3.ZERO
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

onready var map: Sprite3D = $"%Map"
onready var map_position: Vector3 = map.translation
onready var camera_viewport = get_node(camera_viewport_path)

func _ready():
	map.translation = Vector3(0, -2, 0)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	map.texture = camera_viewport.get_texture()
	while true:
		$AmbienceAudioPlayer.play()
		yield(get_tree().create_timer(10), "timeout")

func _process(delta: float):
	if Input.is_action_just_pressed("open_map"):
		var tw = create_tween()
		if not map.visible:
			tw.tween_property(map, "translation", map_position, 0.15)
			tw.tween_property(map, "rotation_degrees", Vector3.ZERO, 0.15)
		else:
			tw.tween_property(map, "translation", Vector3(0, -2, 0), 0.15)
			tw.tween_property(map, "rotation_degrees", Vector3(90, 0, 0), 0.15)
		tw.play()
		if map.visible:
			yield(tw, "finished")
		map.visible = not map.visible

	move_body(delta)

func move_body(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	$AnimationPlayer.play("RESET" if input_dir == Vector2.ZERO else "walk")

# warning-ignore:return_value_discarded
	move_and_slide(velocity)

func _input(event):
	if not (event is InputEventMouseMotion): return
	
	rotation.y -= event.relative.x * sensitivity
	$AstronautHelmet.rotation.x = clamp($AstronautHelmet.rotation.x + event.relative.y * sensitivity, -1, 1)
