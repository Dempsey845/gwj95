extends Node

var zones: Array[Zone]

var checkpoint_zone = 0

var world_scene: PackedScene = preload("uid://j2b3l3a67coe")

func load_zone():
	if get_tree().current_scene is not World:
		return
	
	zones = get_tree().current_scene.zones

	await get_tree().create_timer(2.0).timeout

	zones[checkpoint_zone].spawn_zone()

func reload_scene():
	for zone in zones:
		await zone.destroy_zone()
		
	load_zone()
	zones[checkpoint_zone].move_player_to_start()
