class_name NPC_Group
extends Node

@export var npcs: Dictionary[Marker3D, PackedScene]

func spawn_group():
    var npc_arr: Array[Node3D]
    for spawn_point in npcs:
        var npc_scene = npcs[spawn_point]
        var npc = npc_scene.instantiate()
        spawn_point.add_child(npc)
        npc_arr.append(npc)
    return npc_arr

