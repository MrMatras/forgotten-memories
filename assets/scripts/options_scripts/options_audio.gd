extends Control

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/menu_scenes/menu.tscn")

func _on_graphics_button_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/options_scenes/options_graphics.tscn")
