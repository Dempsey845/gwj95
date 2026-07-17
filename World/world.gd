class_name World
extends Node3D

@export var objective_ui: ObjectiveUI 
@export var zones: Array[Zone]

@onready var main_viewport: SubViewport = %MainViewport

var player: Player

func _ready() -> void:
    player = main_viewport.get_node("Player")