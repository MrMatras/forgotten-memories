extends CharacterBody3D

const SPEED = 2.0
const JUMP_VELOCITY = 2.5
const MOUSE_SENSITIVITY = 0.3

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rotation_x = 0.0
var cassette_mode = false
var original_rotation_x = 0.0

var is_zoomed: bool = false
var normal_camera_position: Vector3 = Vector3(0, 0, 0)
var zoom_camera_position: Vector3 = Vector3(0, 0, -0.7)
var vignette_material: ShaderMaterial #шейдер

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
	normal_camera_position = camera.position
	_create_vignette_effect()

func _create_vignette_effect():
	vignette_material = ShaderMaterial.new()
	vignette_material.shader = load("res://assets/shaders/zoom_blur.gdshader")
	vignette_material.set_shader_parameter("vignette_strength", 0.0)
	vignette_material.set_shader_parameter("blur_strength", 0.0)
	call_deferred("_create_backbuffer_effect")

func _create_backbuffer_effect():
	#cоздаем backbuffercopy
	var back_buffer = BackBufferCopy.new()
	back_buffer.name = "ZoomBackBuffer"
	back_buffer.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT
	
	#создаем colorrect с шейдером
	var color_rect = ColorRect.new()
	color_rect.name = "ZoomEffect"
	color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	color_rect.material = vignette_material
	
	#проверка на размер
	color_rect.size = get_viewport().get_visible_rect().size
	back_buffer.add_child(color_rect)
	get_tree().current_scene.add_child(back_buffer)	
	#скрываем сразу
	color_rect.visible = false

func _process(_delta):
	if pause_menu and not pause_menu.is_player_movement_allowed():
		return

func _input(event):
	if get_tree().paused:
		return
	if event is InputEventMouseMotion and not cassette_mode:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))
		rotation_x -= deg_to_rad(event.relative.y * MOUSE_SENSITIVITY)
		rotation_x = clamp(rotation_x, deg_to_rad(-89), deg_to_rad(89))
		camera.rotation.x = rotation_x
	
	if event.is_action_pressed("zoom_toggle") and not cassette_mode:
		toggle_camera_zoom()
	
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
			_unpause_game()
		else:
			_pause_game()

func _physics_process(delta):
	if not cassette_mode and not get_tree().paused:
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

func _pause_game():
	get_tree().paused = true
	pause_menu.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#выключаем эффект при паузе
	_set_effect_visible(false)
	#выходим из зума при паузе
	if is_zoomed:
		_force_exit_zoom()

func _unpause_game():
	get_tree().paused = false
	pause_menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#был зум = включаем эффект
	if is_zoomed:
		_set_effect_visible(true)

@warning_ignore("shadowed_variable_base_class")
func _set_effect_visible(visible: bool):
	var effect_node = get_tree().current_scene.find_child("ZoomEffect", true, false)
	if effect_node:
		effect_node.visible = visible

func _force_exit_zoom():
	if is_zoomed:
		camera.position = normal_camera_position
		_update_vignette(0.0)
		_set_effect_visible(false)
		is_zoomed = false
		print("Принудительный выход из зума")

func toggle_camera_zoom():
	if is_zoomed:
		_exit_zoom()
	else:
		_enter_zoom()

func _enter_zoom():
	if get_tree().paused:
		return
		
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera, "position", zoom_camera_position, 0.5)
	tween.parallel().tween_method(_update_vignette, 0.0, 1.0, 0.5)
	_set_effect_visible(true)
	is_zoomed = true

func _exit_zoom():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera, "position", normal_camera_position, 0.5)
	tween.parallel().tween_method(_update_vignette, 1.0, 0.0, 0.5)
	await get_tree().create_timer(0.5).timeout
	_set_effect_visible(false)
	is_zoomed = false

func _update_vignette(amount: float):
	if vignette_material:
		vignette_material.set_shader_parameter("vignette_strength", amount * 0.7)
		vignette_material.set_shader_parameter("blur_strength", amount * 0.8)

func enter_cassette_mode():
	if get_tree().paused:
		return
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
	if is_zoomed:
		_force_exit_zoom()

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
