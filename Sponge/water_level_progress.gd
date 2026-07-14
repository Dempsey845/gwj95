extends ColorRect

@export var player: Player
@export var fill_speed: float = 0.5

var shader_material: ShaderMaterial
var current_water_level: float = 0.0


func _ready() -> void:
	shader_material = material as ShaderMaterial
	
	if shader_material == null:
		push_error("ColorRect does not have a ShaderMaterial!")
		return
	
	var water_level: WaterLevel = player.get_node("PlayerWaterLevel")
	
	current_water_level = water_level.current_water_level / water_level.max_water_level
	
	shader_material.set_shader_parameter(
		"water_level",
		current_water_level
	)
	
	water_level.water_level_changed.connect(_on_water_level_changed)

func _on_water_level_changed(new_water_level: float) -> void:
	var target_level = new_water_level / player.get_node("PlayerWaterLevel").max_water_level
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_method(
		func(value: float):
			shader_material.set_shader_parameter(
				"water_level",
				value
			),
		current_water_level,
		target_level,
		fill_speed
	)
	
	current_water_level = target_level
