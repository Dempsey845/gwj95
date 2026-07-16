extends ColorRect

signal complete

func _ready() -> void:
    var tween = create_tween()
    tween.set_trans(Tween.TRANS_BACK)
    tween.set_ease(Tween.EASE_OUT)
    tween.tween_property(material, "shader_parameter/fill", 1.0, 3.0)
    await tween.finished
    complete.emit()