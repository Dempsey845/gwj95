extends Control

@export var player: Player

@onready var smooth_fill: TextureRect = $SmoothFill
@onready var fill: TextureRect = $Fill

var max_health: int
var tween: Tween

func _ready() -> void:
	var health: Health = player.get_node("Health")
	var water_level: WaterLevel = player.get_node("PlayerWaterLevel")

	max_health = health.max_health

	health.damage_taken.connect(_on_damage_taken)
	health.healed.connect(_on_healed)
	
	water_level.water_damage_taken.connect(_on_damage_taken)

	var progress := float(health.current_health) / max_health
	fill.material.set_shader_parameter("progress", progress)
	smooth_fill.material.set_shader_parameter("progress", progress)

	player.reset_triggered.connect(func():
		fill.material.set_shader_parameter("progress", 1.0)
		smooth_fill.material.set_shader_parameter("progress", 1.0)
	)

func _kill_tween() -> void:
	if tween:
		tween.kill()

func _on_damage_taken(_amount: int, current_health:  int) -> void:
	var progress := float(current_health) / max_health

	fill.material.set_shader_parameter("progress", progress)

	_kill_tween()

	tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(
		smooth_fill.material,
		"shader_parameter/progress",
		progress,
		0.3
	)

func _on_healed(_amount: int, current_health:  int) -> void:
	var progress := float(current_health) / max_health

	smooth_fill.material.set_shader_parameter("progress", progress)

	_kill_tween()

	tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(
		fill.material,
		"shader_parameter/progress",
		progress,
		0.3
	)
