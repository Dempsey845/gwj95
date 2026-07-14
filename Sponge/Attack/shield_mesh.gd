extends MeshInstance3D

@export var spin_speed: Vector3 = Vector3(0.5, 1.2, 0.3)
@export var wobble_amount: float = 0.12
@export var wobble_speed: float = 1.8

var time: float = 0.0

func _process(delta):
	time += delta

	# Constant rotation
	rotate_x(spin_speed.x * delta)
	rotate_y(spin_speed.y * delta)
	rotate_z(spin_speed.z * delta)

	# Smooth wobble
	rotation.x += sin(time * wobble_speed) * wobble_amount * delta
	rotation.z += cos(time * wobble_speed * 0.8) * wobble_amount * delta