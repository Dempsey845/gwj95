class_name PlayerAttackController
extends Node

@export var hand_water_meshes: Array[MeshInstance3D]
@export var water_level: WaterLevel

@onready var animation_controller: PlayerAnimationController = $"../PlayerAnimationController"
@onready var fire_point: Marker3D = %FirePoint

var water_projectile_scene: PackedScene = preload("uid://csme2pndgnevr")

var charge_time: float
var is_charging: bool
var has_started_charge: bool

const CHARGE_THRESHOLD: float = 0.2
const MIN_CHARGE_TIME: float = 1.0

const NORMAL_ATTACK_COST: float = 10.0
const CHARGED_ATTACK_COST: float = 20.0

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
			start_charged_attack()
	
	if Input.is_action_just_released("attack") and is_charging:
		is_charging = false

		if has_started_charge:
			if charge_time > MIN_CHARGE_TIME:
				if water_level.current_water_level >= CHARGED_ATTACK_COST:
					water_level.current_water_level -= CHARGED_ATTACK_COST
					end_charged_attack()
				else:
					fail_charge_attack()
			else:
				fail_charge_attack()
		else:
			if water_level.current_water_level >= NORMAL_ATTACK_COST:
				water_level.current_water_level -= NORMAL_ATTACK_COST
				normal_attack()
		
func fail_charge_attack():
	set_hand_water_transparency(1.0, 0.5)
	set_upper_body_blend(0.0, func():
		is_attacking = false
	, 0.5)

func start_charged_attack():
	set_upper_body_blend(1.0, Callable())
	set_hand_water_transparency(0.0, 1.0)
	animation_controller.attack_state_machine_playback.travel("start_charge")

func end_charged_attack():
	set_hand_water_transparency(1.0, 0.5)
	animation_controller.attack_state_machine_playback.travel("release_charge")
	shoot_water_projectile()

func end_charged_animation():
	set_upper_body_blend(0.0, func():
		is_attacking = false
	, 0.1)

func normal_attack():
	set_upper_body_blend(1.0, Callable())
	animation_controller.attack_state_machine_playback.travel("shoot")
	is_attacking = true

	get_tree().create_timer(0.35).timeout.connect(func():
		shoot_water_projectile(0.5, false, 1)
	)

func start_end_attack():
	set_upper_body_blend(0.0, func():
		is_attacking = false
	)

func shoot_water_projectile(scale: float = 1.0, apply_splash_damage: bool = true, damage: int = 2):
	var water_projectile: Area3D = water_projectile_scene.instantiate()
	water_projectile.global_transform = fire_point.global_transform
	water_projectile.scale = Vector3.ONE * scale
	water_projectile.use_splash_zone = apply_splash_damage
	water_projectile.damage = damage
	get_tree().current_scene.add_child(water_projectile)

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