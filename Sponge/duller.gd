extends MeshInstance3D

@export var water_level: WaterLevel

var material: ShaderMaterial

func _ready():
	material = get_active_material(0)

	water_level.water_level_changed.connect(func(new_water_level: float):
		set_dull_amount(1.0 - (new_water_level / water_level.max_water_level))
	)

func set_dull_amount(dull_amount: float):
	dull_amount = clampf(dull_amount, 0.0, 0.5)

	material.set_shader_parameter(
		"dull_amount",
		dull_amount
	)
