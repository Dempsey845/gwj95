extends Node

@onready var player_detection_area: Area3D = $'../PlayerDetectionArea'
@onready var spike_points: Node3D = $'../SpikePoints'
@onready var search_timer: Timer = $SearchTimer
@onready var health: Health = $'../Health'

var urchin: Hurtbox
var spike_scene = preload("uid://pfb47bcyaeh3")

func _ready() -> void:
	urchin = get_parent()

	search_timer.timeout.connect(_on_search_timer_timeout)

	health.death.connect(_on_death)

func get_random_spike_point() -> Marker3D:
	return spike_points.get_children().pick_random()

func _on_search_timer_timeout():
	var overlapping_areas = player_detection_area.get_overlapping_areas()

	if overlapping_areas.size() == 0:
		return

	var player = overlapping_areas[0]

	var spike_point = get_random_spike_point()
	var aim_at_point: Vector3 = player.global_position + Vector3.UP

	spike_point.look_at(aim_at_point)

	var spike: Hitbox = spike_scene.instantiate()

	spike_point.add_child(spike)

func _on_death():
	urchin.queue_free()
