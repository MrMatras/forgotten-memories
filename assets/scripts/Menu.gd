extends CanvasLayer

func _on_start_game_pressed():
	if BgMusic.playing:
		BgMusic.stop()
		get_tree().change_scene_to_file("res://assets/scenes/game.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/options.tscn")

func _on_quit_pressed():
	get_tree().quit()
