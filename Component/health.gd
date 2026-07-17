class_name Health
extends Node

signal health_changed(health: int)
signal damage_taken(amount: int, health: int)
signal healed(amount: int, health: int)
signal death

@export var max_health: int = 3

var dead: bool

var _current_health: int = 1
var current_health: int:
	get():
		return _current_health
	set(value):
		_current_health = value
		health_changed.emit(value)

func _ready() -> void:
	current_health = max_health

func take_damage(damage: int):
	current_health -= damage
	damage_taken.emit(damage, current_health)

	if !dead and current_health <= 0:
		death.emit()
		dead = true

func heal(amount: int):
	current_health += amount
	current_health = min(current_health, max_health)
	healed.emit(amount, current_health)