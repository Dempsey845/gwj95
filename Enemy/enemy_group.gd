class_name EnemyGroup
extends Node

@export var enemies: Dictionary[Marker3D, PackedScene]

func spawn_group(player: Player):
	var enemy_arr: Array[Node3D]
	for spawn_point in enemies:
		var enemy_scene = enemies[spawn_point]
		var enemy: Node3D = enemy_scene.instantiate()
		if enemy.has_method("add_player"):
			enemy.add_player(player)
		get_tree().current_scene.main_viewport.add_child(enemy)
		enemy.global_position = spawn_point.global_position
		enemy.global_rotation = spawn_point.global_rotation
		enemy_arr.append(enemy)
	return enemy_arr
