class_name WaterPuddle
extends Area3D

@export var y_offset: float =  0.6
@export var heal_amount: int = 5
@export_range(1.0, 20.0, 0.5) var drain_duration: float = 3.0

var player_health: Health

var start_y: float

var is_player_in_area: bool

var heal_timer: float

var drain_speed: float
var health_per_second: int

func _ready() -> void:
	await get_tree().process_frame

	var world: World = get_tree().current_scene
	var player: Player = world.player

	player_health = player.get_node("Health")

	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

	start_y = global_position.y

	drain_speed = y_offset / drain_duration
	health_per_second = ceili(heal_amount / drain_duration)

func _process(delta: float) -> void:
	if is_player_in_area:
		if global_position.y > start_y - y_offset:
			global_position.y -= drain_speed * delta

			heal_timer += delta

			if heal_timer > 1.0:
				heal_timer = 0.0

				player_health.heal(health_per_second)
		


func _on_area_entered(_area: Area3D):
	is_player_in_area = true

func _on_area_exited(_area: Area3D):
	is_player_in_area = false
	heal_timer = 0.0

func reset():
	heal_timer = 0.0
	is_player_in_area = false
	global_position.y = start_y