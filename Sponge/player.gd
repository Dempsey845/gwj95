class_name Player
extends CharacterBody3D

# SM64-style character controller

@export_category("Movement")
@export var max_speed : float = 10.0

@export var ground_acceleration: float = 35.0
@export var ground_deceleration: float = 20.0
@export var air_acceleration : float = 8.0

@export_category("Slopes")
@export var slope_acceleration: float = 18.0
@export var slope_max_speed: float = 14.0
@export var slope_friction: float = 8.0

@export_category("Jump")
@export var jump_force: float = 11.0
@export var gravity: float = 28.0

@export var jump_cut_multiplier: float = 0.5
@export var jump_hold_gravity: float = 12.0

@export_category("Long Jump")
@export var long_jump_force: float = 14.0
@export var long_jump_vertical: float = 7.0
@export var long_jump_speed_bonus: float = 6.0

@export_category("Wall Jump")
@export var wall_jump_force: float = 11.0
@export var wall_jump_push: float = 10.0

@export var wall_check_distance: float = 1.0

@export_category("Rotation")
@export var turn_speed: float = 10.0
@export var skid_turn_speed: float = 3.0
@export var skid_threshold: float = 5.0

@export_category("Jump Forgiveness")
@export var jump_buffer_time: float = 0.15
@export var coyote_time: float = 0.15

@onready var spring_arm: SpringArm3D = $CameraSpring
@onready var armature: Node3D = $Armature

var jump_buffer: float = 0.0
var coyote_timer: float = 0.0

var is_jumping: bool = false
var is_skidding: bool = false
var is_long_jumping: bool = false

var last_wall_normal: Vector3 = Vector3.ZERO

func _physics_process(delta):
	# Jump Buffer	
	if Input.is_action_just_pressed("jump"):
		jump_buffer = jump_buffer_time


	if jump_buffer > 0:
		jump_buffer -= delta

	# Coyote Time	
	if is_on_floor():

		coyote_timer = coyote_time
		is_long_jumping = false

	else:

		coyote_timer -= delta

	# Input	
	var input = Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_back"
	)

	# Camera Direction	
	var cam_forward = spring_arm.global_transform.basis.z
	var cam_right = spring_arm.global_transform.basis.x

	cam_forward.y = 0
	cam_right.y = 0

	cam_forward = cam_forward.normalized()
	cam_right = cam_right.normalized()

	var direction = (
		cam_forward * input.y +
		cam_right * input.x
	).normalized()

	# Momentum + Slopes	
	var horizontal_velocity = Vector3(
		velocity.x,
		0,
		velocity.z
	)

	if is_on_floor():
		var floor_normal = get_floor_normal()

		# Slope force
		var slope_direction = Vector3.DOWN.slide(
			floor_normal
		)

		if slope_direction.length() > 0.01:

			slope_direction = slope_direction.normalized()

			horizontal_velocity += (
				slope_direction *
				slope_acceleration *
				delta
			)

		# Input acceleration
		if direction != Vector3.ZERO:

			horizontal_velocity += (
				direction *
				ground_acceleration *
				delta
			)
		else:

			horizontal_velocity = horizontal_velocity.move_toward(
				Vector3.ZERO,
				slope_friction * delta
			)

		var current_max_speed = max_speed

		if slope_direction.y < -0.1:

			current_max_speed = slope_max_speed

		if horizontal_velocity.length() > current_max_speed:

			horizontal_velocity = (
				horizontal_velocity.normalized()
				* current_max_speed
			)
	else:
		# Air movement
		if direction != Vector3.ZERO:

			horizontal_velocity += (
				direction *
				air_acceleration *
				delta
			)
		if horizontal_velocity.length() > max_speed:

			horizontal_velocity = (
				horizontal_velocity.normalized()
				* max_speed
			)

	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z

	# Jump System	
	if jump_buffer > 0:
		# Wall kick
		if not is_on_floor() and check_wall():
			velocity.y = wall_jump_force

			velocity.x += last_wall_normal.x * wall_jump_push
			velocity.z += last_wall_normal.z * wall_jump_push

			jump_buffer = 0
			is_jumping = true

		# Long jump
		elif is_on_floor() and Input.is_action_pressed("crouch"):
			var forward = -armature.global_transform.basis.z

			forward.y = 0
			forward = forward.normalized()

			# Current horizontal momentum
			var current_velocity = Vector3(
				velocity.x,
				0,
				velocity.z
			)

			var current_speed = current_velocity.length()

			# Keep current direction if moving
			# Otherwise use facing direction
			if current_speed > 0.1:

				current_velocity = current_velocity.normalized()

			else:

				current_velocity = forward

			# Add bonus based on current speed
			var launch_speed = (
				current_speed +
				long_jump_speed_bonus
			)

			# Cap it
			launch_speed = min(
				launch_speed,
				long_jump_force
			)

			velocity.x = current_velocity.x * launch_speed
			velocity.z = current_velocity.z * launch_speed

			velocity.y = long_jump_vertical

			is_long_jumping = true

			jump_buffer = 0
			coyote_timer = 0

		# Normal jump
		elif coyote_timer > 0:
			velocity.y = jump_force

			jump_buffer = 0
			coyote_timer = 0

			is_jumping = true
	
	# Variable Jump Height	
	if Input.is_action_just_released("jump") and is_jumping:
		if velocity.y > 0:
			velocity.y *= jump_cut_multiplier

	if Input.is_action_pressed("jump") and velocity.y > 0:
		velocity.y -= jump_hold_gravity * delta
	
	# Gravity	
	if not is_on_floor():
		if is_long_jumping:
			velocity.y -= gravity * 0.6 * delta
		else:
			velocity.y -= gravity * delta

	# Facing + Skidding	
	var movement_velocity = Vector3(
		velocity.x,
		0,
		velocity.z
	)

	if movement_velocity.length() > 0.1:
		var move_direction = movement_velocity.normalized()

		var target_rotation = atan2(
			move_direction.x,
			move_direction.z
		)

		var speed = movement_velocity.length()

		if direction != Vector3.ZERO:
			var dot = move_direction.dot(direction)
			if speed > skid_threshold and dot < -0.3:
				is_skidding = true

				armature.rotation.y = lerp_angle(
					armature.rotation.y,
					atan2(direction.x, direction.z),
					skid_turn_speed * delta
				)
			else:
				is_skidding = false

				var current_turn_speed = lerp(
					turn_speed,
					3.0,
					speed / max_speed
				)

				armature.rotation.y = lerp_angle(
					armature.rotation.y,
					target_rotation,
					current_turn_speed * delta
				)
		else:
			armature.rotation.y = lerp_angle(
				armature.rotation.y,
				target_rotation,
				turn_speed * delta
			)

	move_and_slide()


func check_wall() -> bool:
	var space_state = get_world_3d().direct_space_state

	var params = PhysicsRayQueryParameters3D.new()

	params.from = global_position + Vector3.UP * 0.5

	params.to = (
		global_position +
		Vector3.UP * 0.5 -
		transform.basis.z * wall_check_distance
	)

	params.exclude = [self]

	var result = space_state.intersect_ray(params)

	if result:
		last_wall_normal = result.normal
		return true

	last_wall_normal = Vector3.ZERO
	return false
