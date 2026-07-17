extends Area3D


func _ready() -> void:
	area_entered.connect(func(_area: Area3D):
		if CheckpointManager.checkpoint_zone == 0:
			CheckpointManager.checkpoint_zone = 1
			CheckpointManager.load_zone()
	)
