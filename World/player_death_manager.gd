extends Node

@export var player: Player
@export var canvas_layer: CanvasLayer

var water_fill_scene = preload("uid://c3tuvwur02le0")

var loading_screen_scene: PackedScene = preload("uid://mxpgc6tsme2i")

func _ready() -> void:
	var health: Health = player.get_node("Health")
	health.death.connect(func():
		var water_fill = water_fill_scene.instantiate()
		canvas_layer.add_child(water_fill)

		await water_fill.get_child(0).complete
		CheckpointManager.reload_scene()
	)
	
