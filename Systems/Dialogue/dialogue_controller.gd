class_name DialogueController
extends Node

@export var dialogue_ui: DialogueUI

@export var dialogue: Dialogue
@export var icon_texture: CompressedTexture2D

func _ready() -> void:
	await get_tree().process_frame
	if dialogue_ui == null:
		dialogue_ui = get_tree().current_scene.get_node("CanvasLayer").get_node("DialogueUI")

func start():
	DialogueManager.instance.start(dialogue, dialogue_ui, icon_texture)
	
