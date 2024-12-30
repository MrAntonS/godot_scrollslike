extends CharacterBody3D

const SPEED = 7.0
var speed := SPEED
const SPRINT_INCREASE = 1.3
const JUMP_VELOCITY = 4.5
const SENSETIVITY = 0.005
const BASE_FOV = 90.0
const SPRINT_FOV = 110.0
var shake := 0
var t := 0

@onready var head := $Head
@onready var camera := $Head/Camera3D


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSETIVITY)
		camera.rotate_x(-event.relative.y * SENSETIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("Sprint") and is_on_floor():
		camera.position.y = sin(shake * 0.3) * 0.06
		camera.position.x = cos(shake * 0.3 / 2) * 0.09
		shake += 1
		speed = SPEED * SPRINT_INCREASE
		camera.fov = lerp(camera.fov, SPRINT_FOV, delta * 3)
	else:
		shake = 0
		speed = SPEED
		camera.fov = lerp(camera.fov, BASE_FOV, delta*4)
	if Input.is_action_pressed("Crouch"):
		head.position.y = 0
	else:
		head.position.y = 1.9
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Rigth", "Forward", "Back")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction and is_on_floor():
		velocity.x = direction.x * speed * 1.00003 ** t * delta * 60
		velocity.z = direction.z * speed * 1.00003 ** t * delta * 60
		t += 1
		
	elif direction and not is_on_floor():
		velocity.x += direction.x * speed * 2 * delta
		velocity.z += direction.z * speed * 2 * delta
	elif not direction and is_on_floor():
		velocity.x = 0.0
		velocity.z = 0.0
		t = 0

	move_and_slide()
