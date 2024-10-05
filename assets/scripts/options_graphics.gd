extends Control

func _on_button_audio_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/options.tscn")

func _on_button_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/menu.tscn")
