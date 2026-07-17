class_name Zone
extends Node3D

signal zone_spawned
signal zone_destroyed

@export var npc_groups: Array[NPC_Group]
@export var enemy_groups: Array[EnemyGroup]
@export var puddle_groups: Array[PuddleGroup]
@export var start_point: Marker3D

@export var player: Player

var enemies: Array[Node3D]
var npcs: Array[Node3D]

func spawn_zone():
	for npc_group in npc_groups:
		npcs += npc_group.spawn_group()

	for enemy_group in enemy_groups:
		enemies += enemy_group.spawn_group(player)

	for puddle in puddle_groups:
		puddle.reset_puddles()

	zone_spawned.emit()

func destroy_zone():
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.queue_free()
			await enemy.tree_exited
	
	for npc in npcs:
		if is_instance_valid(npc):
			npc.queue_free()
			await npc.tree_exited
	
	enemies = []
	npcs = []
	
	zone_destroyed.emit()

func move_player_to_start():
	player.global_position = start_point.global_position
	player.reset()
