extends Control

func _on_audio_button_pressed():
	FixGraphicSettings.last_scene = "graphics"
	var tween = create_tween().set_parallel(true)
	tween.tween_property($res_text, "position:x", -1500, 1.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($window_text, "position:x", -1500, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($vsync_label, "position:x", -1500, 0.8).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($show_fps_option_label, "position:x", -1500, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.55).timeout
	get_tree().change_scene_to_file("res://assets/scenes/options_scenes/options.tscn")

func _on_back_button_pressed():
	var tween = create_tween().set_parallel(true)
	tween.tween_property($back_button/audio_button, "position:y", -2500, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($back_button/graphics_button, "position:y", -2500, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($back_button/gamesettings_button, "position:y", -2500, 1.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($back_button, "position:y", 1500, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($res_text, "position:x", -1500, 1.8).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($window_text, "position:x", -1500, 1.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($vsync_label, "position:x", -1500, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($show_fps_option_label, "position:x", -1500, 1.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.7).timeout
	get_tree().change_scene_to_file("res://assets/scenes/menu_scenes/menu.tscn")

func _ready():
#виды экрана
	$res_text/resolution_button.add_item("1920x1080")
	$res_text/resolution_button.add_item("1600x900")
	$res_text/resolution_button.add_item("1280x720")
#режим экрана
	$window_text/windowmode_button.add_item("Windowed")
	$window_text/windowmode_button.add_item("Fullscreen")
	$window_text/windowmode_button.add_item("Borderless Fullscreen")
#подключаем сигналы без привязки через узел
	$res_text/resolution_button.connect("item_selected", Callable(self, "_on_resolution_selected"))
	$window_text/windowmode_button.connect("item_selected", Callable(self, "_on_windowmode_selected"))
#анимации
	$res_text.position.x = -624
	$window_text.position.x = -888
	$vsync_label.position.x = -1192
	$show_fps_option_label.position.x = -1080
	var tween = create_tween().set_parallel(true)
	tween.tween_property($res_text, "position:x", 64, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($window_text, "position:x", 64, 1.15).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($vsync_label, "position:x", 64, 1.45).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($show_fps_option_label, "position:x", 64, 1.35).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func _on_resolution_selected(index):
	var res = $res_text/resolution_button.get_item_text(index).split("x")
	var width = int(res[0])
	var height = int(res[1])
	DisplayServer.window_set_size(Vector2i(width, height))

func _on_windowmode_selected(index):
	match index:
		0: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func _on_vsync_check_box_pressed():
  #ненавижу эту верт.синхронизацию
	var current_vsync = DisplayServer.window_get_vsync_mode()
	if current_vsync == DisplayServer.VSYNC_ENABLED:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)

func _on_fps_checkbox_toggled(pressed: bool) -> void:
	FPSDisplay.set_visible_fps(pressed)
