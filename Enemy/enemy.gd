extends Node3D

@onready var health: Health = $Health

func _ready() -> void:
	health.death.connect(func():
		queue_free()
	)
	