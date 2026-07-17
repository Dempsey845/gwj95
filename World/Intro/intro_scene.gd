extends Node3D

@onready var animation_player: AnimationPlayer = $TransitionRect/AnimationPlayer
@onready var dialogue_manager: DialogueManager = $DialogueManager

var world_scene: PackedScene = preload("uid://j2b3l3a67coe")

func _ready() -> void:
	dialogue_manager.start_game.connect(func():
		animation_player.play("out")
		await animation_player.animation_finished
		get_tree().change_scene_to_packed(world_scene)
	)

