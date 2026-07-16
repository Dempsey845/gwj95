class_name WaterLevel
extends Node

signal water_level_changed(new_water_level: float)

@export var health: Health

var _current_water_level: float = 500.0
var current_water_level: float:
	get():
		return _current_water_level
	set(value):
		_current_water_level = value
		water_level_changed.emit(value)

var max_water_level: float = 500.0

var water_splash_effect_scene:PackedScene = preload("uid://chbrcr8s2cb72")
@onready var hit_effect_point: Marker3D = $'../HitEffectPoint'

func _ready() -> void:
	await get_tree().process_frame
	water_level_changed.emit(current_water_level)

	health.damage_taken.connect(func(amount: int, _health_value: int):
		current_water_level -= amount * (max_water_level / health.max_health)
		var effect = water_splash_effect_scene.instantiate()
		hit_effect_point.add_child(effect)
		effect.global_position = hit_effect_point.global_position
	)

	health.healed.connect(func(amount: int, _health_value: int):
		current_water_level += amount * (max_water_level / health.max_health)
	)
