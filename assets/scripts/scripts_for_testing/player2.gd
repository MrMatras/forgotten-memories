extends CharacterBody3D

const SPEED = 2.0
const JUMP_VELOCITY = 2.5
const MOUSE_SENSITIVITY = 0.3

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rotation_x = 0.0
var cassette_mode = false
var original_rotation_x = 0.0

@onready var head = $head
@onready var camera = $head/camera
@onready var cassette_container = $cassette_container
@onready var ray = $head/camera/raycast_cam
@onready var pause_menu = $"../pausemenu"

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	original_rotation_x = camera.rotation.x
	cassette_container.visible = false
	ray.enabled = true
	pause_menu.visible = false

func _process(_delta):
	if pause_menu and not pause_menu.is_player_movement_allowed():
		return

func _input(event):
	if event is InputEventMouseMotion and not cassette_mode:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))
		rotation_x -= deg_to_rad(event.relative.y * MOUSE_SENSITIVITY)
		rotation_x = clamp(rotation_x, deg_to_rad(-89), deg_to_rad(89))
		camera.rotation.x = rotation_x
	if event.is_action_pressed("cassette_interaction"):
		if cassette_mode:
			exit_cassette_mode()
		else:
			enter_cassette_mode()
	if cassette_mode and event is InputEventMouseButton and event.pressed and event.button_index == 1:
		if ray.is_colliding():
			var collider = ray.get_collider()
			play_cassette(collider)
	if event.is_action_pressed("escape"):
		if get_tree().paused:
			#выкл паузу
			get_tree().paused = false
			pause_menu.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			#вкл паузу
			get_tree().paused = true
			pause_menu.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	if not cassette_mode:
		if not is_on_floor():
			velocity.y -= gravity * delta
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

func enter_cassette_mode():
	cassette_mode = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	cassette_container.visible = true
	var player_pos = global_transform.origin
	var forward = -global_transform.basis.z.normalized()
	cassette_container.global_transform.origin = player_pos + forward * 0.4
	cassette_container.global_transform.origin.y = player_pos.y - 0.4
	cassette_container.get_node("cassette_1").position = Vector3(0.25, -0.3, 0)
	cassette_container.get_node("cassette_2").position = Vector3(0, -0.3, 0)
	cassette_container.get_node("cassette_3").position = Vector3(-0.25, -0.3, 0)
	var tween = create_tween()
	tween.tween_property(camera, "rotation_degrees:x", -35, 0.5)

func exit_cassette_mode():
	cassette_mode = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cassette_container.visible = false
	var tween = create_tween()
	tween.tween_property(camera, "rotation:x", original_rotation_x, 0.6)

func play_cassette(cassette):
	var audio = $head/camera/AudioStreamPlayer3D
	match cassette.name:
		"cassette_1":
			audio.stream = preload("res://assets/sounds/analog_mannequin - milkcassettex.mp3")
		"cassette_2":
			audio.stream = preload("res://assets/sounds/analog_mannequin - milkcassettex.mp3")
		"cassette_3":
			audio.stream = preload("res://assets/sounds/analog_mannequin - milkcassettex.mp3")
	audio.play()
	exit_cassette_mode()
