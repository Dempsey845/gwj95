class_name World
extends Node3D

@export var objective_ui: ObjectiveUI 
@export var zones: Array[Zone]

@onready var main_viewport: SubViewport = %MainViewport