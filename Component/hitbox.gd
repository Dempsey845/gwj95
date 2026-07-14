class_name Hitbox
extends Area3D

signal hit
signal hit_hurtbox(hurtbox: Hurtbox)

func _ready() -> void:
    area_entered.connect(_on_area_entered)

func _on_area_entered(other: Area3D):
    if other is Hurtbox:
        other.register_hit()
        hit_hurtbox.emit(other)
        hit_hurtbox_extend(other)
    
    hit.emit()

func hit_hurtbox_extend(hurtbox: Hurtbox):
    pass