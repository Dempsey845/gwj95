extends Node

var zones: Array[Zone]

var checkpoint_zone = 0

var world_scene: PackedScene = preload("uid://j2b3l3a67coe")

func load_zone():
	if get_tree().current_scene is not World:
		return
	
	zones = get_tree().current_scene.zones

	print("Loading zone!")

	await get_tree().create_timer(2.0).timeout

	zones[checkpoint_zone].spawn_zone()

func reload_scene():
	get_tree().reload_current_scene()
	await get_tree().scene_changed
	load_zone()
		
func load_world_scene():
	get_tree().change_scene_to_packed.call_deferred(world_scene)
	await get_tree().scene_changed
	load_zone()
