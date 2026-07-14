extends Node

@onready var animation_controller: PlayerAnimationController = $"../PlayerAnimationController"

var charge_time: float
var is_charging: bool
var has_started_charge: bool

const CHARGE_THRESHOLD: float = 0.2
const MIN_CHARGE_TIME: float = 1.0

var blend_tween: Tween
var is_attacking: bool

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and !is_attacking:
		is_charging = true
		has_started_charge = false
		charge_time = 0.0
	
	if is_charging:
		charge_time += delta

		if !has_started_charge and charge_time >= CHARGE_THRESHOLD:
			has_started_charge = true
			start_charged_attack()
	
	if Input.is_action_just_released("attack") and is_charging:
		is_charging = false

		if has_started_charge:
			if charge_time > MIN_CHARGE_TIME:
				print("Charge attack!")
				end_charged_attack()
			else:
				print("Charge attack failed!")
				set_upper_body_blend(0.0, func():
					is_attacking = false
				, 0.5)
		else:
			normal_attack()
		
func start_charged_attack():
	set_upper_body_blend(1.0, Callable())
	animation_controller.attack_state_machine_playback.travel("start_charge")

func end_charged_attack():
	animation_controller.attack_state_machine_playback.travel("release_charge")

func end_charged_animation():
	set_upper_body_blend(0.0, func():
		is_attacking = false
	, 0.1)

func normal_attack():
	set_upper_body_blend(1.0, Callable())
	animation_controller.attack_state_machine_playback.travel("shoot")
	is_attacking = true

func start_end_attack():
	set_upper_body_blend(0.0, func():
		is_attacking = false
	)

func set_upper_body_blend(amount: float, callback: Callable, time: float = 0.25):
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
		time
	)

	blend_tween.tween_callback(callback)
