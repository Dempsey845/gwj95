class_name CameraController
extends SpringArm3D

@export var sensitivity: float = 0.003

var pitch: float = 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * sensitivity

		pitch -= event.relative.y * sensitivity
		pitch = clamp(pitch, deg_to_rad(-60), deg_to_rad(75))

		rotation.x = pitch

	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event.is_action_pressed("focus"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
