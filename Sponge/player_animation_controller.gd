class_name PlayerAnimationController
extends Node

@onready var animation_tree: AnimationTree = $"../AnimationTree"

@export var blend_speed : float = 8.0
@export var jump_blend_speed : float = 10.0

var state_machine_playback: AnimationNodeStateMachinePlayback
var attack_state_machine_playback: AnimationNodeStateMachinePlayback

var body: CharacterBody3D

var current_blend : Vector2 = Vector2.ZERO
var current_jump_blend : float = 0.0

func _ready() -> void:
	body = get_parent()

	state_machine_playback = animation_tree.get("parameters/StateMachine/playback")
	attack_state_machine_playback = animation_tree.get("parameters/AttackStateMachine/playback")

func _process(delta):
	var input := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_back"
	)

	var target_blend := Vector2(
		input.x,
		-input.y
	)

	var weight := 1.0 - exp(-blend_speed * delta)

	current_blend = current_blend.lerp(
		target_blend,
		weight
	)

	animation_tree.set(
		"parameters/StateMachine/movement/blend_position",
		current_blend
	)

	if is_sliding_down_slope():
		state_machine_playback.travel("slide")
	else:
		if not body.is_on_floor():
			state_machine_playback.travel("jump")
		else:
			if Input.is_action_pressed("crouch"):
				state_machine_playback.travel("crouch")
			else:
				state_machine_playback.travel("movement")

func is_sliding_down_slope() -> bool:
	if not body.is_on_floor():
		return false

	var floor_normal = body.get_floor_normal()
	var floor_angle = rad_to_deg(acos(floor_normal.dot(Vector3.UP)))

	const SLIDE_START_ANGLE = 10.0

	# Get downhill direction
	var slope_direction = Vector3.DOWN.slide(
		floor_normal
	).normalized()

	# No slope
	if floor_angle < SLIDE_START_ANGLE:
		return false

	# Current horizontal movement
	var movement = Vector3(
		body.velocity.x,
		0,
		body.velocity.z
	)

	# Not moving
	if movement.length() < 0.1:
		return false

	movement = movement.normalized()

	var dot = movement.dot(slope_direction)

	return dot > 0.5
