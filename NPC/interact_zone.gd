class_name InteractZone
extends Area3D

signal interacted

@onready var icon: MeshInstance3D = $Icon

var player_in_zone: bool
var tween: Tween

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

	icon.transparency = 1.0

func _process(_delta: float) -> void:
	if player_in_zone and Input.is_action_just_pressed("interact"):
		interacted.emit()

func _on_area_entered(_area: Area3D) -> void:
	player_in_zone = true
	_fade_icon(0.0)

func _on_area_exited(_area: Area3D) -> void:
	player_in_zone = false
	_fade_icon(1.0)

func _fade_icon(target: float) -> void:
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(icon, "transparency", target, 0.2)