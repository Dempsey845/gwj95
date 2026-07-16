class_name EnemyGroup
extends Node

@export var enemies: Dictionary[Marker3D, PackedScene]

func spawn_group(player: Player):
    for spawn_point in enemies:
        var enemy_scene = enemies[spawn_point]
        var enemy = enemy_scene.instantiate()
        enemy.player = player
        spawn_point.add_child(enemy)

