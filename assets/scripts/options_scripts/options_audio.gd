extends Control

func _ready():
	$audio_button.position.y = -120
	$graphics_button.position.y = -248
	$gamesettings_button.position.y = -376
	$back_button.position.y = 1336
	if FixGraphicSettings.last_scene == "menu":
		$sound.position.x = -976
		$sfx.position.x = -728
		var tween = create_tween().set_parallel(true)
		tween.tween_property($audio_button, "position:y", 72, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($graphics_button, "position:y", 72, 1.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($gamesettings_button, "position:y", 76, 1.35).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($back_button, "position:y", 960, 1.45).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($sound, "position:x", 96, 1.55).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($sfx, "position:x", 96, 1.55).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	else:
		$audio_button.position.y = 72
		$graphics_button.position.y = 72
		$gamesettings_button.position.y = 76
		$back_button.position.y = 960
		$sound.position.x = -976
		$sfx.position.x = -728
		var tween = create_tween().set_parallel(true)
		tween.tween_property($sound, "position:x", 96, 1.55).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($sfx, "position:x", 96, 1.55).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

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
	tween.tween_property($sound, "position:x", -1000, 1.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($sfx, "position:x", -1500, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.8).timeout
	get_tree().change_scene_to_file("res://assets/scenes/options_scenes/options_graphics.tscn")
