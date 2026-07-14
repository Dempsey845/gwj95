extends Hitbox

@onready var life_timer: Timer = %LifeTimer
@onready var splash_zone: Area3D = $SplashZone

var move_speed: float = 25.0
var damage: int = 1
var use_splash_zone: bool

func _ready() -> void:
    super._ready()
    life_timer.timeout.connect(func():
        queue_free()
    )

func _physics_process(delta: float) -> void:
    position += transform.basis.z * move_speed * delta

func hit_hurtbox_extend(hurtbox: Hurtbox):
    if use_splash_zone:
        var overlapping_areas = splash_zone.get_overlapping_areas()
        for area in overlapping_areas:
            if area == hurtbox:
                continue

            if area is Hurtbox:
                area.register_hit(damage)

