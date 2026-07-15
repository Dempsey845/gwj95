class_name DialogueManager
extends Node

static var instance: DialogueManager

var current_dialogue: Dialogue
var current_node: int = 0

func _ready() -> void:
	instance = self

func start(dialogue: Dialogue, dialogue_ui: DialogueUI, icon_texture: CompressedTexture2D) -> void:
	current_dialogue = dialogue
	current_node = 0

	dialogue_ui.open_dialogue(icon_texture)
	await dialogue_ui.animation_player.animation_finished

	await _run_dialogue(dialogue_ui)

func _run_dialogue(dialogue_ui: DialogueUI) -> void:
	while true:
		var node: DialogueNode = current_dialogue.nodes[current_node]

		dialogue_ui.start_dialogue_text(node.text)
		await dialogue_ui.typing_complete

		if node.event != "":
			trigger_event(node.event)
			
		await dialogue_ui.user_advance

		if node.next == -1:
			break

		current_node = node.next

	dialogue_ui.close_dialogue()

func trigger_event(event: String) -> void:
	match event:
		"start_tortoise_quest":
			pass
		"give_forest_key":
			pass