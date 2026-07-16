class_name Zone
extends Node3D

@export var npc_groups: Array[NPC_Group]
@export var enemy_groups: Array[EnemyGroup]

@export var player: Player

func _ready() -> void:
    await get_tree().create_timer(5.0).timeout
    spawn_zone()

func spawn_zone():
    for npc_group in npc_groups:
        npc_group.spawn_group()

    for enemy_group in enemy_groups:
        enemy_group.spawn_group(player)
