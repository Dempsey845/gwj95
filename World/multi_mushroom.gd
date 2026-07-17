extends MultiMeshInstance3D

@export var mushroom_count := 500
@export var area_size := Vector2(100, 100)
@export var max_size: float = 3.0
@export var min_size: float = 0.8

func _ready():
	multimesh.instance_count = mushroom_count

	for i in mushroom_count:
		var pos = Vector3(
			randf_range(-area_size.x / 2.0, area_size.x / 2.0),
			0.0,
			randf_range(-area_size.y / 2.0, area_size.y / 2.0)
		)

		var shroom_rot = randf_range(0.0, TAU)
		var shroom_scale= randf_range(min_size, max_size)

		var shroom_basis = Basis()
		shroom_basis = shroom_basis.rotated(Vector3.UP, shroom_rot)
		shroom_basis = shroom_basis.scaled(Vector3.ONE * shroom_scale)

		var shroom_transform = Transform3D(shroom_basis, pos)

		multimesh.set_instance_transform(i, shroom_transform)
