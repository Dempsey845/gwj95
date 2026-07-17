extends Node3D

@onready var enemy_group: EnemyGroup = $VolCrabEnemyGroup

var crab_scene: PackedScene = preload("uid://bbetthmc0ggs6")

func _ready() -> void:
	for child in get_children():
		if child is EnemyGroup:
			continue
		
		var marker: Marker3D = child

		enemy_group.enemies[marker] = crab_scene
