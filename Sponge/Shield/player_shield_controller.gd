extends Node

@export var water_level: WaterLevel

@onready var player_attack_controller: PlayerAttackController = $"../PlayerAttackController"
@onready var shield_mesh: MeshInstance3D = $'../ShieldMesh'
@onready var shield_cooldown_timer: Timer = $ShieldCooldownTimer
@onready var shield_hurtbox: Hurtbox = $'../ShieldMesh/Hurtbox'

const COST_PER_SECOND = 5.0

var is_shielding: bool

var shield_tween: Tween

func _process(delta: float) -> void:
	var can_attack = !player_attack_controller.is_charging and !player_attack_controller.is_attacking

	if Input.is_action_pressed("shield") and can_attack and shield_cooldown_timer.is_stopped():
		is_shielding = true
		shield_hurtbox.monitorable = true
		set_shield_transparency(0.0, 1.0)
	
	if Input.is_action_just_released("shield") and is_shielding:
		is_shielding = false
		stop_shield()

	if is_shielding:
		if !can_attack or water_level.current_water_level < COST_PER_SECOND:
			stop_shield()
		
		water_level.current_water_level -= COST_PER_SECOND * delta

func stop_shield():
	shield_cooldown_timer.start()
	set_shield_transparency(1.0, 0.5)
	shield_hurtbox.monitorable = false

func set_shield_transparency(amount: float, time: float):
	if shield_tween:
		shield_tween.kill()
	
	shield_tween = create_tween()
	shield_tween.tween_method(func(value):
		shield_mesh.transparency = value,
		shield_mesh.transparency,
		amount,
		time
	)
