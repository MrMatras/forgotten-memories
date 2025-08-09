extends CharacterBody3D

const SPEED = 2.0
const JUMP_VELOCITY = 2.0
const MOUSE_SENSITIVITY = 0.3

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rotation_x = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		#вращение по горизонтали (ось y)
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))
		#вращение по вертикали (ось X)
		rotation_x -= deg_to_rad(event.relative.y * MOUSE_SENSITIVITY) 
		rotation_x = clamp(rotation_x, deg_to_rad(-89), deg_to_rad(89)) 
		$head/camera.rotation.x = rotation_x

func _physics_process(delta):
	#добавление гравитации
	if not is_on_floor():
		velocity.y -= gravity * delta

	#прыжок
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
