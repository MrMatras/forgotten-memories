extends Control

func _on_vsync_check_box_pressed():
	#fucked this v-sync
	var current_vsync = DisplayServer.window_get_vsync_mode()
	if current_vsync == DisplayServer.VSYNC_ENABLED:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
