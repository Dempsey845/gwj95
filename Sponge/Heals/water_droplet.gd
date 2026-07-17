extends Area3D

@export var heal_amount: int = 1

@onready var life_timer: Timer = $LifeTimer

var velocity: Vector3 = Vector3.ZERO

var effect_scene: PackedScene = preload("uid://g63t1n138cbj")

func _ready() -> void:
	area_entered.connect(_on_area_entered)

	life_timer.timeout.connect(func():
		queue_free.call_deferred()
	)

func _physics_process(delta: float) -> void:
	velocity.y -= 9 * delta
	global_position += velocity * delta

func _on_area_entered(area: Area3D) -> void:
	var health = area.get_parent().get_node_or_null("Health")
	if health:
		health.heal(heal_amount)

	var effect = effect_scene.instantiate()
	get_tree().current_scene.main_viewport.add_child(effect)
	effect.global_position = global_position
	queue_free()