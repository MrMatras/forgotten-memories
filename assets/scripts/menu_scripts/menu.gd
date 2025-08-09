extends CanvasLayer

func _ready():
	$Title.position.y = -120;
	$startgame.position.x = -240
	$options.position.x = -280
	$credits.position.x = -336
	$quit.position.x = -368
	var tween = create_tween().set_parallel(true)
	tween.tween_property($Title, "position:y", 136, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($startgame, "position:x", 72, 1.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($options, "position:x", 72, 1.35).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($credits, "position:x", 64, 1.45).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($quit, "position:x", 72, 1.55).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/scenes_for_testing_anything/game_test.tscn")

func _on_settings_pressed():
	FixGraphicSettings.last_scene = "menu"
	var tween = create_tween().set_parallel(true)
	tween.tween_property($Title, "position:y", -1000, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($startgame, "position:x", -1500, 1.8).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($options, "position:x", -1500, 1.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($credits, "position:x", -1500, 1.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($quit, "position:x", -1500, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://assets/scenes/options_scenes/options.tscn")

func _on_quit_pressed():
	get_tree().quit()
