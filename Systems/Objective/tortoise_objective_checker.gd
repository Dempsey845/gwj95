extends Node



@onready var check_timer: Timer = $CheckTimer

var objective_controller: ObjectiveController

func _ready() -> void:
	objective_controller = get_parent()

	objective_controller.objective_started.connect(func():
		check_timer.start()
	)

	check_timer.timeout.connect(func():
		if ObjectiveManager.instance.jellyfishKilled >= 5:
			objective_controller.stop_objective()
			check_timer.stop()
			DialogueManager.instance.jellyfish_objective_complete.emit()
	)
