extends ProgressBar

func _ready() -> void:
	value = 0.0
	start_loading()

func start_loading() -> void:
	var duration = 3

	var tween= create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "value", max_value, duration)

	await tween.finished

	get_parent().get_parent().visible = false

    
