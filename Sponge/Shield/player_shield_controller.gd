extends Node

@onready var player_attack_controller: PlayerAttackController = $"../PlayerAttackController"
@onready var shield_mesh: MeshInstance3D = $'../ShieldMesh'
@onready var shield_cooldown_timer: Timer = $ShieldCooldownTimer

var is_shielding: bool

var shield_tween: Tween

func _process(_delta: float) -> void:
	var can_attack = !player_attack_controller.is_charging and !player_attack_controller.is_attacking

	if Input.is_action_pressed("shield") and can_attack and shield_cooldown_timer.is_stopped():
		is_shielding = true
		set_shield_transparency(0.0, 1.0)
	
	if Input.is_action_just_released("shield") and is_shielding:
		is_shielding = false
		stop_shield()

	if is_shielding and !can_attack:
		stop_shield()

func stop_shield():
	shield_cooldown_timer.start()
	set_shield_transparency(1.0, 0.5)

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
