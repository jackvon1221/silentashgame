extends CharacterBody3D

@export var speed := 5.5
@export var gravity := 20.0
@export var jump_velocity := 6.0
@export var mouse_sensitivity := 0.003
@export var pitch_sensitivity := 0.003

@onready var camera: Camera3D = $CameraPivot/Camera3D

var camera_pitch := 0.0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Rotate player (yaw)
		rotation.y -= event.relative.x * mouse_sensitivity

		# Rotate camera (pitch only)
		camera_pitch -= event.relative.y * pitch_sensitivity
		camera_pitch = clamp(camera_pitch, -1.2, 0.3)
		camera.rotation.x = camera_pitch

	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process(delta: float) -> void:
	# --- INPUT ---
	var input_dir := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)

	# --- SIMPLE, RELIABLE MOVEMENT ---
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# --- GRAVITY ---
	if not is_on_floor():
		velocity.y -= gravity * delta

	# --- JUMP ---
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	move_and_slide()
