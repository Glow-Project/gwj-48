extends KinematicBody

signal lost()

export var speed: float = 5
export var sensitivity: float = 0.005
export var camera_viewport_path: NodePath
export var controllable: bool = true
export var has_microphone: bool = false
export var radio_equipped: bool = false

var velocity := Vector3.ZERO
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var queued_radio_playbacks := []

onready var map: Sprite3D = $"%Map"
onready var map_position: Vector3 = map.translation
onready var oxygen_position: Vector3 = $AstronautHelmet/Oxygen .translation
onready var camera_viewport = get_node(camera_viewport_path)

func _ready():
	Global.connect("player_equipped_radio", self, "_radio_equipped")
	map.translation = Vector3(0, -2, 0)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$ArrowAnimationPlayer.play("default")
	$Menu.get_node("%MouseSensitivity").value = sensitivity
	map.texture = camera_viewport.get_texture()
	for voiceline_trigger in get_tree().get_nodes_in_group("voiceline_trigger"):
		voiceline_trigger.connect("triggered", self, "_receive_radio_signal")
	while true:
		$AmbienceAudioPlayer.play()
		yield(get_tree().create_timer(10), "timeout")

func _process(delta: float):
	if not controllable: return
	handle_input()
	move_body(delta)

func handle_input():
	if Input.is_action_just_pressed("open_map"):
		var tw = create_tween()
		tw.tween_property(map, "translation", map_position, 0.15)
		tw.tween_property(map, "rotation_degrees", Vector3.ZERO, 0.15)
		tw.play()
		map.visible = true
	elif Input.is_action_just_released("open_map"):
		var tw = create_tween()
		tw.tween_property(map, "translation", Vector3(0, -2, 0), 0.15)
		tw.tween_property(map, "rotation_degrees", Vector3(90, 0, 0), 0.15)
		tw.play()
		yield(tw, "finished")
		map.visible = false

func move_body(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= (gravity / 4) * delta

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
	if not controllable or not (event is InputEventMouseMotion): return
	
	rotation.y -= event.relative.x * sensitivity
	$AstronautHelmet.rotation.x = clamp($AstronautHelmet.rotation.x + event.relative.y * sensitivity, -1, 1)


func _radio_equipped():
	$AmbienceAnimationPlayer.play("silent_alarm")
	$AmbienceAudioPlayer.stream = preload("res://assets/breathing.mp3")
	radio_equipped = true
	$AIAudioPlayer.stream = preload("res://assets/voicelines/ai_radio_equipped.mp3")
	$AIAudioPlayer.play()

func queue_radio_playback(audio):
	if (not $RadioPlayback.playing) and radio_equipped:
		$RadioPlayback.stream = audio
		$RadioPlayback.play()
	else:
		queued_radio_playbacks.append(audio)

func _receive_radio_signal(audio):
	queue_radio_playback(audio)

func _on_RadioPlayback_finished():
	if (not queued_radio_playbacks.empty()) and radio_equipped:
		# prevent the radio from playing the next audio immediately
		yield(get_tree().create_timer(0.5), "timeout")
		$RadioPlayback.stream = queued_radio_playbacks.pop_front()
		$RadioPlayback.play()


func _on_Oxygen_empty():
	emit_signal("lost")
	$AIAudioPlayer.stream = preload("res://assets/voicelines/ai_oxygen_level_empty3.mp3")
	$AIAudioPlayer.play()


func _on_Menu_update_mouse_sensitivity(value: float):
	sensitivity = value
