extends CanvasLayer

var can_player_move = true
var is_pause_animation_playing = false

func _ready():
	$menu/ColorRect/title.position.x = -744
	$menu/ColorRect/continue.position.x = -240
	$menu/ColorRect/settings.position.x = -376
	$menu/ColorRect/exit_to_menu.position.x = -552
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

func _input(event):
	if event.is_action_pressed("escape") and not is_pause_animation_playing:
		toggle_pause()

func toggle_pause():
	if get_tree().paused:
		resume_game()
	else:
		pause_game()

func pause_game():
	is_pause_animation_playing = true
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = true
	can_player_move = false
	var tween = create_tween().set_parallel(true)
	tween.tween_property($menu/ColorRect/continue, "position:x", 64, 0.9).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($menu/ColorRect/settings, "position:x", 64, 1.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($menu/ColorRect/exit_to_menu, "position:x", 64, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($menu/ColorRect/title, "position:x", 64, 0.9).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await tween.finished
	is_pause_animation_playing = false
	can_player_move = true

func resume_game():
	is_pause_animation_playing = true
	can_player_move = false
	var tween = create_tween().set_parallel(true)
	tween.tween_property($menu/ColorRect/continue, "position:x", -240, 0.7).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($menu/ColorRect/settings, "position:x", -376, 0.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($menu/ColorRect/exit_to_menu, "position:x", -552, 0.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($menu/ColorRect/title, "position:x", -744, 0.7).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await tween.finished
	visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	is_pause_animation_playing = false
	can_player_move = true

func _on_continue_pressed():
	if not is_pause_animation_playing:
		resume_game()

func _on_settings_pressed():
	print("потом добавлю отдельно")

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://assets/scenes/menu_scenes/menu.tscn")

func is_player_movement_allowed():
	return can_player_move and not is_pause_animation_playing and not get_tree().paused
