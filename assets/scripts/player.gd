extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const BOB_FREQ = 2.0
const BOB_AMP = 0.08

var t_bob = 0.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var camera = $head/camera                         

func _physics_process(delta):
	#гравитация
	if not is_on_floor():
		velocity.y -= gravity * delta

	#обработка прыжка
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	#ввод и обработка движений
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Покачивание камеры
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin.y = _headbob(t_bob).y  # Применяем только Y-координату покачивания
	
	move_and_slide()

func _headbob(time) -> Vector3:
	return Vector3(0, sin(time * BOB_FREQ) * BOB_AMP, 0)
