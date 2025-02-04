extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 12

var xForm : Transform3D

func _physics_process(delta: float) -> void:
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Play character animations
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		$AnimationPlayer.play("jump")
	elif is_on_floor() and input_dir != Vector2.ZERO:
		$AnimationPlayer.play("run")
	elif is_on_floor() and input_dir == Vector2.ZERO:
		$AnimationPlayer.play("idle")
	# Orbit camera around player
	if Input.is_action_just_pressed("camera_left"):
		$Camera_Controller.rotate_y(deg_to_rad(30))
	
	if Input.is_action_just_pressed("camera_right"):
		$Camera_Controller.rotate_y(deg_to_rad(-30))
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
	# New Vector 3 to account for user arrow inputs and camera rotation
	var direction = ($Camera_Controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Rotate character mesh to face the direction the player is moving
	if input_dir != Vector2(0, 0):
		$Armature.rotation_degrees.y = $Camera_Controller.rotation_degrees.y - rad_to_deg(input_dir.angle()) - 90
	
	# Rotatae the character to align with the floor
	if is_on_floor():
		align_with_floor($RayCast3D.get_collision_normal())
		global_transform = global_transform.interpolate_with(xForm, 0.3)
	elif not is_on_floor():	
		align_with_floor(Vector3.UP)
		global_transform = global_transform.interpolate_with(xForm, 0.3)
	# Update velocity and move character
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	# Make camera controller to match root position of player
	$Camera_Controller.position = lerp($Camera_Controller.position,position,0.15)

func align_with_floor(floor_normal):
	xForm = global_transform
	xForm.basis.y = floor_normal
	xForm.basis.x = -xForm.basis.z.cross(floor_normal)
	xForm.basis = xForm.basis.orthonormalized()


func _on_fall_zone_body_entered(body: Node3D) -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
