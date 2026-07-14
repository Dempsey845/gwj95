extends Area3D

@onready var life_timer: Timer = %LifeTimer

var move_speed: float = 25.0

func _ready() -> void:
    life_timer.timeout.connect(func():
        queue_free()
    )

func _physics_process(delta: float) -> void:
    position += transform.basis.z * move_speed * delta