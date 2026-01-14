extends CharacterBody3D

@onready var camera_pivot := $CameraPivot

const SPEED := 5.0
const JUMP_VELOCITY := 4.5
const ROTATION_SPEED := 10.0
const MOUSE_SENSITIVITY := 0.003

var camera_pitch := -0.3


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Rotate player left/right with mouse
		rotation.y -= event.relative.x * MOUSE_SENSITIVITY

		# Tilt camera up/down
		camera_pitch -= event.relative.y * MOUSE_SENSITIVITY
		camera_pitch = clamp(camera_pitch, -1.2, 0.3)
		camera_pivot.rotation.x = camera_pitch


func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement input (WASD)
	var input_dir := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)

	# Camera-relative movement direction
	var cam_basis: Basis = camera_pivot.global_transform.basis
	var direction := cam_basis.x * input_dir.x + cam_basis.z * input_dir.y
	direction.y = 0

	if direction.length() > 0.01:
		direction = direction.normalized()

		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
