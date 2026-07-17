extends Node3D

@export var drop_area: Vector3 = Vector3(10, 1, 10)

@onready var timer: Timer = $Timer

var water_droplet_scene: PackedScene = preload("uid://c0op4qyj5allw")

func _ready() -> void:
	timer.timeout.connect(spawn_droplet)

func spawn_droplet() -> void:
	var droplet = water_droplet_scene.instantiate()

	var offset = Vector3(
		randf_range(-drop_area.x * 0.5, drop_area.x * 0.5),
		randf_range(-drop_area.y * 0.5, drop_area.y * 0.5),
		randf_range(-drop_area.z * 0.5, drop_area.z * 0.5)
	)

	get_tree().current_scene.main_viewport.add_child(droplet)
	droplet.global_position = global_position + offset
