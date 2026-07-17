extends Node3D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var hitbox: Hitbox = $Hitbox

@export var knockback_force: float = 12.0
@export var knockback_up_force: float = 6.0

var body: CharacterBody3D
var playback: AnimationNodeStateMachinePlayback

var is_hit_animation: bool

func _ready() -> void:
	body = get_parent()

	playback = animation_tree.get("parameters/playback")
	playback.travel("walk")

	hitbox.hit_hurtbox.connect(func(hurtbox: Hurtbox):
		is_hit_animation = true
		playback.travel("hit")

		if hurtbox.get_parent() is Player:
			var player: CharacterBody3D = hurtbox.get_parent()

			var knockback_direction := (
				player.global_position - body.global_position
			).normalized()

			player.velocity.x = knockback_direction.x * knockback_force
			player.velocity.z = knockback_direction.z * knockback_force
			player.velocity.y = knockback_up_force

		await animation_tree.animation_finished
		is_hit_animation = false
	)


func _process(_delta: float) -> void:
	if is_hit_animation:
		return

	if body.velocity.length() > 0.1:
		playback.travel("walk")
	else:
		playback.travel("idle")
