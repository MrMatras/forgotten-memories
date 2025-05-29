extends Control

func _on_audio_button_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/options_scenes/options.tscn")

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/menu_scenes/menu.tscn")



func _ready():
#виды экрана
	$resolution_button.add_item("1920x1080")
	$resolution_button.add_item("1600x900")
	$resolution_button.add_item("1280x720")
#режим экрана
	$windowmode_button.add_item("Windowed")
	$windowmode_button.add_item("Fullscreen")
	$windowmode_button.add_item("Bordless Fullscreen")
#подключаем сигналы без привязки через узел
	$resolution_button.connect("item_selected", Callable(self, "_on_resolution_selected"))
	$windowmode_button.connect("item_selected", Callable(self, "_on_windowmode_selected"))

func _on_resolution_selected(index):
	var res = $resolution_button.get_item_text(index).split("x")
	var width = int(res[0])
	var height = int(res[1])
	DisplayServer.window_set_size(Vector2i(width, height))

func _on_windowmode_selected(index):
	match index:
		0: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)



func _on_vsync_check_box_pressed():
  #fucked this v-sync
	var current_vsync = DisplayServer.window_get_vsync_mode()
	if current_vsync == DisplayServer.VSYNC_ENABLED:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)


@onready var fps_label = $"../fps_label"
@onready var fps_checkbox = $show_fps_option_label/fps_checkbox

func _process(_delta):
	if fps_label.visible:
		fps_label.text = "FPS: %d" % Engine.get_frames_per_second()

func _on_fps_checkbox_toggled(pressed: bool) -> void:
	fps_label.visible = pressed
