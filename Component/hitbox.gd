class_name Hitbox
extends Area3D

signal hit
signal hit_hurtbox(hurtbox: Hurtbox)

@export var active: bool = true
@export var free_on_hit: bool = true

func _ready() -> void:
    area_entered.connect(_on_area_entered)

func _on_area_entered(other: Area3D):
    if not active:
        return

    if other is Hurtbox:
        other.register_hit()
        hit_hurtbox.emit(other)
        hit_hurtbox_extend(other)
    
    hit.emit()
    if free_on_hit:
        queue_free.call_deferred()

func hit_hurtbox_extend(_hurtbox: Hurtbox):
    pass

func check_for_hurtbox():
    active = true
    var areas = get_overlapping_areas()
    for area in areas:
        print(area)
        _on_area_entered(area)
    active = false
