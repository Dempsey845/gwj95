extends Node

@onready var animation_controller: PlayerAnimationController = $"../PlayerAnimationController"

var blend_tween: Tween

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		set_upper_body_blend(1.0)
		animation_controller.attack_state_machine_playback.travel("shoot")


func end_attack():
	print("Attack ended")
	set_upper_body_blend(0.0)


func set_upper_body_blend(amount: float):
	if blend_tween:
		blend_tween.kill()

	blend_tween = create_tween()
	blend_tween.tween_method(
		func(value):
			animation_controller.animation_tree.set(
				"parameters/UpperBodyBlend/blend_amount",
				value
			),
		animation_controller.animation_tree.get(
			"parameters/UpperBodyBlend/blend_amount"
		),
		amount,
		0.25
	)