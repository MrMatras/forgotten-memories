extends Control

func _ready():
	#настраиваем позиции
	setup_initial_positions()
	#запускаем анимации
	start_animations()
	#подключаем локалку и шрифты
	setup_localization()

func setup_initial_positions():
	$audio_button.position.y = -120
	$graphics_button.position.y = -248
	$gamesettings_button.position.y = -376
	$back_button.position.y = 1336
	
	if FixGraphicSettings.last_scene == "menu":
		$sound.position.x = -976
		$sfx.position.x = -1100
	else:
		$audio_button.position.y = 72
		$graphics_button.position.y = 72
		$gamesettings_button.position.y = 76
		$back_button.position.y = 960
		$sound.position.x = -976
		$sfx.position.x = -1200

func start_animations():
	var tween = create_tween().set_parallel(true)
	
	if FixGraphicSettings.last_scene == "menu":
		tween.tween_property($audio_button, "position:y", 72, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($graphics_button, "position:y", 72, 1.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($gamesettings_button, "position:y", 76, 1.35).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($back_button, "position:y", 960, 1.45).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($sound, "position:x", 96, 1.35).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($sfx, "position:x", 96, 1.45).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	else:
		tween.tween_property($sound, "position:x", 96, 1.55).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($sfx, "position:x", 96, 1.55).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func setup_localization():
	LocalizationAutoload.language_changed.connect(_on_language_changed)
	update_audio_text()

func update_audio_text():
	var current_locale = LocalizationAutoload.get_current_locale()
	var font = LocalizationAutoload.get_font_for_locale(current_locale)
	if font:
		apply_audio_font(font)
	#обновляем текст после изменеия шрифта
	$audio_button.text = LocalizationAutoload.get_text("options_audio/audio_button")
	$graphics_button.text = LocalizationAutoload.get_text("options_audio/graphics_button")
	$gamesettings_button.text = LocalizationAutoload.get_text("options_audio/gamesettings_button")
	$back_button.text = LocalizationAutoload.get_text("options_audio/back_button")
	$sound.text = LocalizationAutoload.get_text("options_audio/sound")
	$sfx.text = LocalizationAutoload.get_text("options_audio/sfx")

func apply_audio_font(font: Font):
	#применяем шрифт ко всем настройкам
	$audio_button.add_theme_font_override("font", font)
	$graphics_button.add_theme_font_override("font", font)
	$gamesettings_button.add_theme_font_override("font", font)
	$back_button.add_theme_font_override("font", font)
	$sound.add_theme_font_override("font", font)
	$sfx.add_theme_font_override("font", font)

func _on_language_changed(_locale):
	update_audio_text()

func _on_back_button_pressed():
	var tween = create_tween().set_parallel(true)
	tween.tween_property($audio_button, "position:y", -1500, 1.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($graphics_button, "position:y", -1500, 1.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($gamesettings_button, "position:y", -1500, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($back_button, "position:y", 1500, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($sound, "position:x", -1500, 1.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($sfx, "position:x", -1500, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://assets/scenes/menu_scenes/menu.tscn")

func _on_graphics_button_pressed():
	var tween = create_tween().set_parallel(true)
	tween.tween_property($sound, "position:x", -1000, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($sfx, "position:x", -1500, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.8).timeout
	get_tree().change_scene_to_file("res://assets/scenes/options_scenes/options_graphics.tscn")

func _on_volume_slider_value_changed(value):
	var menu_music = AudioServer.get_bus_index("Master")
	var db_value
	if value == 0:
		db_value = -80  #тишина
	else:
		db_value = linear_to_db(value / 100.0)
	AudioServer.set_bus_volume_db(menu_music, db_value)
	#музыка не ебашит
	if value == 0:
		AudioServer.set_bus_mute(menu_music, true)
	else:
		AudioServer.set_bus_mute(menu_music, false)
