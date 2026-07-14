extends Hitbox

@export var move_speed: float = 15.0
@export var move: bool = true
@onready var life_timer: Timer = $LifeTimer

func _ready() -> void:
    super._ready()
    life_timer.timeout.connect(func(): queue_free())

func _process(delta: float) -> void:
    if move:
        global_position += -global_basis.z * move_speed * delta