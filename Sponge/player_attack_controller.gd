class_name PlayerAttackController
extends Node

@export var hand_water_meshes: Array[MeshInstance3D]
@export var water_level: WaterLevel

@onready var animation_controller: PlayerAnimationController = $"../PlayerAnimationController"
@onready var fire_point: Marker3D = %FirePoint
@onready var enemy_detection_area: Area3D = %EnemyDetectionArea
@onready var targer_search_timer: Timer = $TargerSearchTimer
@onready var target_billboard: TargetBillboard = $'../TargetBillboard'

var water_projectile_scene: PackedScene = preload("uid://csme2pndgnevr")

var charge_time: float
var is_charging: bool
var has_started_charge: bool

const CHARGE_THRESHOLD: float = 0.2
const MIN_CHARGE_TIME: float = 0.5

const NORMAL_ATTACK_COST: float = 10.0
const CHARGED_ATTACK_COST: float = 20.0

var blend_tween: Tween
var is_attacking: bool

var water_tween: Tween

var default_fire_point_rotation: Vector3

func _ready() -> void:
	default_fire_point_rotation = fire_point.rotation
	targer_search_timer.timeout.connect(try_look_at_nearest_enemy)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and !is_attacking and !DialogueManager.instance.in_dialogue and water_level.current_water_level >= NORMAL_ATTACK_COST:
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

		if DialogueManager.instance.in_dialogue:
			fail_charge_attack()
			return

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

func try_look_at_nearest_enemy():
	fire_point.rotation = default_fire_point_rotation

	var overlapping_areas = enemy_detection_area.get_overlapping_areas()

	if overlapping_areas.size() > 0:
		var closest_area_distance_sq: float = INF
		var closest_area: Area3D
		var player: Player = get_parent()

		for area in overlapping_areas:
			var distance_sq_to_area = player.global_position.distance_squared_to(area.global_position)
			if distance_sq_to_area < closest_area_distance_sq:
				closest_area = area
				closest_area_distance_sq = distance_sq_to_area
		
		var target_point = closest_area.global_position + Vector3.UP

		if target_billboard.target_node == null:
			target_billboard.global_position = target_point
			target_billboard.fade_transparency(0.5)
			target_billboard.pop_in()

		target_billboard.target_node = closest_area
		
		fire_point.look_at(target_point, Vector3.UP, true)
	else:
		target_billboard.target_node = null
		target_billboard.pop_out()
		target_billboard.fade_transparency(1.0)
			
	

func shoot_water_projectile(scale: float = 1.0, apply_splash_damage: bool = true, damage: int = 2):
	try_look_at_nearest_enemy()

	var water_projectile: Area3D = water_projectile_scene.instantiate()
	water_projectile.global_transform = fire_point.global_transform
	water_projectile.scale = Vector3.ONE * scale
	water_projectile.use_splash_zone = apply_splash_damage
	water_projectile.damage = damage
	get_tree().current_scene.main_viewport.add_child(water_projectile)

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
