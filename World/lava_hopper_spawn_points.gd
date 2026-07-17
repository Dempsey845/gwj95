extends Node3D

@onready var enemy_group: EnemyGroup = $LavaHopperEnemyGroup

var lava_hopper_scene: PackedScene = preload("uid://c0nbq1dkyi1gl")

func _ready() -> void:
	for child in get_children():
		if child is EnemyGroup:
			continue
		
		var marker: Marker3D = child

		enemy_group.enemies[marker] = lava_hopper_scene
