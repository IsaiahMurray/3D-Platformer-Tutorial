extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 12

var xForm : Transform3D

func _physics_process(delta: float) -> void:
	
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

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# New Vector 3 to account for user arrow inputs and camera rotation
	var direction = ($Camera_Controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Rotate character mesh to face the direction the player is moving
	if input_dir != Vector2(0, 0):
		$MeshInstance3D.rotation_degrees.y = $Camera_Controller.rotation_degrees.y - rad_to_deg(input_dir.angle()) - 90
	
	# Rotatae the character to align with the floor
	if is_on_floor():
		align_with_floor($RayCast3D.get_collision_normal())
		global_transform = xForm
		
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
