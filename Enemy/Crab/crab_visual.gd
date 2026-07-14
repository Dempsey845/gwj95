extends Node3D

@export var enemy: Enemy

@onready var animation_tree: AnimationTree = $AnimationTree

var is_moving: bool = false

var move_tween: Tween

func _ready() -> void:
	enemy.start_attack.connect(func():
		animation_tree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	)

func _process(_delta: float) -> void:
	if !enemy.velocity.is_zero_approx() and !is_moving:
		is_moving = true
		blend_move(1.0)
	else:
		is_moving = false
		blend_move(0.0)

func blend_move(target: float):
	if move_tween:
		move_tween.stop()
	
	move_tween = create_tween()

	move_tween.tween_method(
		func(value):
			animation_tree.set(
				"parameters/Speed/blend_amount",
				value
			),
		animation_tree.get(
			"parameters/Speed/blend_amount"
		),
		target,
		0.5
	)

	animation_tree.get("parameters/Speed/blend_amount")
