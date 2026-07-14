class_name WaterLevel
extends Node

signal water_level_changed(new_water_level: float)

@export var health: Health

var _current_water_level: float = 75.0
var current_water_level: float:
	get():
		return _current_water_level
	set(value):
		_current_water_level = value
		water_level_changed.emit(value)

var max_water_level: float = 100.0

func _ready() -> void:
	await get_tree().process_frame
	water_level_changed.emit(current_water_level)

	health.damage_taken.connect(func(amount: int, _health_value: int):
		current_water_level -= amount * (max_water_level / health.max_health)
	)

	health.healed.connect(func(amount: int, _health_value: int):
		current_water_level += amount * (max_water_level / health.max_health)
	)
