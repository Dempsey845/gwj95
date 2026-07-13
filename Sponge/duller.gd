extends MeshInstance3D

var material: ShaderMaterial

func _ready():
	material = get_active_material(0)

func set_dull_amount(dull_amount: float):
	if dull_amount > 0:
		dull_amount /= 2
		
	material.set_shader_parameter(
		"dull_amount",
		dull_amount
	)
