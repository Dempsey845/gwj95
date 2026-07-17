extends ColorRect

signal complete

func _ready() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(material, "shader_parameter/fill", 1.0, 3.0)
	tween.tween_callback(func(): complete.emit())
	tween.tween_interval(2.0)
	tween.tween_property(material, "shader_parameter/fill", 0.0, 3.0)
	tween.tween_callback(func(): get_parent().queue_free())
	