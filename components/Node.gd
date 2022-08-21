tool
extends Spatial

export var broken = false setget set_broken

onready var status_light := $StatusLight

func _ready():
	var color := Color.red if broken else Color.green
	if status_light:
		status_light.light_color = color

func set_broken(value: bool):
	broken = value
	
	var color := Color.red if broken else Color.green
	if status_light:
		status_light.light_color = color
