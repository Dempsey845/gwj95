class_name Zone
extends Node3D

@export var npc_groups: Array[NPC_Group]
@export var enemy_groups: Array[EnemyGroup]
@export var start_point: Marker3D

@export var player: Player

var enemies: Array[Node3D]
var npcs: Array[Node3D]

func spawn_zone():
    for npc_group in npc_groups:
        npcs = npc_group.spawn_group()

    for enemy_group in enemy_groups:
        enemies = enemy_group.spawn_group(player)

func destroy_zone():
    for enemy in enemies:
        enemy.queue_free()
        await enemy.tree_exited
    
    for npc in npcs:
        npc.queue_free()
        await npc.tree_exited

func move_player_to_start():
    player.global_position = start_point.global_position
    player.reset()