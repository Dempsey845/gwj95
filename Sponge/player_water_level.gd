class_name WaterLevel
extends Node

signal water_level_changed(new_water_level: float)
signal water_damage_taken(amount: int, health_value: int)

@export var health: Health

var _current_water_level: float = 250.0
var current_water_level: float:
	get():
		return _current_water_level
	set(value):
		_current_water_level = value
		water_level_changed.emit(value)

var max_water_level: float = 500.0

var water_splash_effect_scene:PackedScene = preload("uid://chbrcr8s2cb72")
@onready var hit_effect_point: Marker3D = $'../HitEffectPoint'

var damage_accumulator: float = 0.0

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
		current_water_level = min(current_water_level, max_water_level)
	)


func _process(delta: float) -> void:
	if current_water_level <= 0:
		damage_accumulator += 0.25 * delta

		if damage_accumulator >= 1.0:
			var damage = int(damage_accumulator)
			health.current_health -= damage
			health.check_if_dead()
			damage_accumulator -= damage
			water_damage_taken.emit(damage, health.current_health)
	else:
		damage_accumulator = 0.0
