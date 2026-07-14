extends Node

@onready var animation_controller: PlayerAnimationController = $"../PlayerAnimationController"

@export var hand_water_meshes: Array[MeshInstance3D]

var charge_time: float
var is_charging: bool
var has_started_charge: bool

const CHARGE_THRESHOLD: float = 0.2
const MIN_CHARGE_TIME: float = 1.0

var blend_tween: Tween
var is_attacking: bool

var water_tween: Tween

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and !is_attacking:
		is_charging = true
		has_started_charge = false
		charge_time = 0.0
	
	if is_charging:
		charge_time += delta

		if !has_started_charge and charge_time >= CHARGE_THRESHOLD:
			has_started_charge = true
			print("Charge started")
			start_charged_attack()
	
	if Input.is_action_just_released("attack") and is_charging:
		is_charging = false

		if has_started_charge:
			if charge_time > MIN_CHARGE_TIME:
				end_charged_attack()
			else:
				set_hand_water_transparency(1.0, 0.5)
				set_upper_body_blend(0.0, func():
					is_attacking = false
				, 0.5)
		else:
			normal_attack()
		
func start_charged_attack():
	set_upper_body_blend(1.0, Callable())
	set_hand_water_transparency(0.0, 1.0)
	animation_controller.attack_state_machine_playback.travel("start_charge")

func end_charged_attack():
	set_hand_water_transparency(1.0, 0.5)
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

func set_hand_water_transparency(amount: float, time: float):
	if water_tween:
		water_tween.kill()
	
	water_tween = create_tween()
	water_tween.tween_method(func(value):
		for hand in hand_water_meshes:
			hand.transparency = value,
		hand_water_meshes[0].transparency,
		amount,
		time
	)