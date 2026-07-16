class_name ObjectiveUI
extends Control

@export var typing_speed: float = 0.03 

@onready var objective_label: Label = %ObjectiveLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _typing: bool

func start_objective(object_text: String) -> void:
	animation_player.play("open")
	await animation_player.animation_finished

	_typing = true
	objective_label.text = object_text
	objective_label.visible_characters = 0

	for i in object_text.length():
		if !_typing:
			return

		objective_label.visible_characters = i + 1
		await get_tree().create_timer(typing_speed).timeout

func stop_objective() -> void:
	_typing = false
	objective_label.text = ""
	animation_player.play_backwards("open")