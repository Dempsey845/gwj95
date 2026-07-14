class_name Hurtbox
extends Area3D

@export var health: Health

func register_hit(damage: int = 1):
	health.take_damage(damage)