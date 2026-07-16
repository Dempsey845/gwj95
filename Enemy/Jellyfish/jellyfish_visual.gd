class_name JellyfishVisual
extends Node3D

@onready var animation_player: AnimationPlayer = $Warning/AnimationPlayer
@onready var fire_point: Marker3D = $FirePoint

var projectile_scene = preload("uid://dmwugw3jv8o2h")

var enemy: Enemy

func _ready() -> void:
    enemy = get_parent()

    enemy.start_attack.connect(_on_start_attack)

    enemy.get_node("Health").death.connect(func():
        ObjectiveManager.instance.jellyfishKilled += 1
    )

func show_warning():
    animation_player.play("show")

func _on_start_attack():
    show_warning()
    await animation_player.animation_finished
    fire_point.look_at(enemy.player.global_position)

    print("Shot")

    var projectile = projectile_scene.instantiate()
    get_tree().current_scene.main_viewport.add_child(projectile)
    projectile.global_transform = fire_point.global_transform

