extends Area3D

@export var transition_animation_player: AnimationPlayer

func _ready() -> void:
	area_entered.connect(func(_area: Area3D):
		transition_animation_player.play("play")
		await get_tree().create_timer(0.5).timeout
		CheckpointManager.checkpoint_zone = 2
		CheckpointManager.reload_scene()
	)
