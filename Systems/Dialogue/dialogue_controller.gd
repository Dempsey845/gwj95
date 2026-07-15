class_name DialogueController
extends Node

@export var dialogue_ui: DialogueUI

@export var dialogue: Dialogue
@export var icon_texture: CompressedTexture2D

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	DialogueManager.instance.start(dialogue, dialogue_ui, icon_texture)
	
