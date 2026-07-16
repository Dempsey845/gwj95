class_name ObjectiveController
extends Node

signal objective_started
signal objective_ended

@export var objective: String

var objective_ui: ObjectiveUI

func _ready() -> void:
    var world: World = get_tree().current_scene

    objective_ui = world.objective_ui

func start_objective():
    objective_started.emit()
    objective_ui.start_objective(objective)

func stop_objective():
    objective_ended.emit()
    objective_ui.stop_objective()