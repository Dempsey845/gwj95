class_name Enemy
extends CharacterBody3D

signal start_attack

@export var player: CharacterBody3D

@export_category("Movement")
@export var move_speed: float = 3.0
@export var chase_distance: float = 20.0
@export var attack_distance: float = 1.5

@export_category("Attack")
@export var attack_cooldown: float = 1.5
var can_attack: bool = true

@onready var health: Health = $Health
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

func _ready() -> void:
	health.death.connect(func():
		queue_free()
	)

	navigation_agent_3d.path_desired_distance = 0.5
	navigation_agent_3d.target_desired_distance = attack_distance


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= 20 * delta
	else:
		velocity.y = 0.0

	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)

	if distance <= attack_distance:
		velocity = Vector3.ZERO
		attack()

	elif distance <= chase_distance:
		chase_player(delta)
		
	else:
		velocity = Vector3.ZERO


	move_and_slide()


func chase_player(_delta: float) -> void:
	navigation_agent_3d.target_position = player.global_position

	if navigation_agent_3d.is_navigation_finished():
		return

	var next_position = navigation_agent_3d.get_next_path_position()

	var direction = global_position.direction_to(next_position)

	velocity = direction * move_speed

	if direction.length() > 0.01:
		look_at(
			global_position + direction,
			Vector3.UP
		)


func attack() -> void:
	if not can_attack:
		return

	start_attack.emit()

	can_attack = false

	await get_tree().create_timer(attack_cooldown).timeout

	can_attack = true

func add_player(plr: Player):
	player = plr
