extends Node

@onready var player_water_level: WaterLevel = $'../PlayerWaterLevel'
@onready var health: Health = $'../Health'

func _ready() -> void:
    get_parent().reset_triggered.connect(reset)

func reset():
    player_water_level.current_water_level = player_water_level.max_water_level
    health.dead = false
    health.current_health = health.max_health