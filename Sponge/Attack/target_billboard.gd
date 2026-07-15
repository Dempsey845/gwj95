class_name TargetBillboard
extends MeshInstance3D

@export var follow_speed: float = 8.0

var target_node: Node3D
var target_offset: Vector3 = Vector3(0, 1.5, 0)

var fade_tween: Tween
var pop_tween: Tween

func _process(delta: float) -> void:
	if not target_node:
		return

	var target_position = target_node.global_position + target_offset
	global_position = global_position.lerp(
		target_position,
		1.0 - exp(-follow_speed * delta)
	)


func fade_transparency(target: float, duration: float = 1.0):
	if fade_tween:
		fade_tween.kill()

	fade_tween = create_tween()
	fade_tween.tween_method(func(value):
		transparency = value
	, transparency, target, duration)


func pop_in(duration: float = 0.3):
	if pop_tween:
		pop_tween.kill()

	var original_scale = scale

	pop_tween = create_tween()
	pop_tween.tween_property(self, "scale", original_scale * 1.15, duration * 0.3)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	pop_tween.tween_property(self, "scale", original_scale, duration * 0.7)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_IN_OUT)


func pop_out(duration: float = 0.3, callable: Callable = Callable()):
	if pop_tween:
		pop_tween.kill()

	var original_scale = scale

	pop_tween = create_tween()
	pop_tween.tween_property(self, "scale", original_scale * 0.85, duration * 0.3)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_IN)
	pop_tween.tween_property(self, "scale", original_scale, duration * 0.7)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	pop_tween.tween_callback(callable)