extends Control

func _on_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/menu.tscn")

var master_bus = AudioServer.get_bus_index("Menu") 

func _on_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, value)

	if value == -30:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)

func _on_button_graphics_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/options_function/options_graphics.tscn")
