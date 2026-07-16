class_name NPC_Group
extends Node

@export var npcs: Dictionary[Marker3D, PackedScene]

func spawn_group():
    for spawn_point in npcs:
        var npc_scene = npcs[spawn_point]
        var npc = npc_scene.instantiate()
        spawn_point.add_child(npc)

