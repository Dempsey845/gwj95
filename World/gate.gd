class_name Gate
extends Node3D

@export var zone: Zone

@onready var collider: CollisionShape3D = %Collider

func _ready() -> void:
	zone.zone_spawned.connect(close_gate)

	zone.zone_destroyed.connect(close_gate)

	DialogueManager.instance.key_given.connect(open_gate)

func open_gate():
	collider.disabled = true
	get_parent().visible = false

func close_gate():
		collider.disabled = false
		get_parent().visible = true
