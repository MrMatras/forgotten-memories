extends CanvasLayer

@onready var title = $menu/ColorRect/title
@onready var continue_btn = $menu/ColorRect/continue  
@onready var settings_btn = $menu/ColorRect/settings_pausemenu
@onready var exit_btn = $menu/ColorRect/exit_to_menu

var can_player_move = true
var is_pause_animation_playing = false

func _ready():
	LocalizationAutoload.language_changed.connect(_on_language_changed)
	update_ui_text()
	
	#позиции
	if title:
		title.position.x = -744
	if continue_btn:
		continue_btn.position.x = -240
	if settings_btn:
		settings_btn.position.x = -376
	if exit_btn:
		exit_btn.position.x = -552
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

func apply_pause_font(font: Font):
	#применяем шрифт ко всем элементам
	if title:
		title.add_theme_font_override("font", font)
	if continue_btn:
		continue_btn.add_theme_font_override("font", font)
	if settings_btn:
		settings_btn.add_theme_font_override("font", font)
	if exit_btn:
		exit_btn.add_theme_font_override("font", font)

func update_ui_text():
	var current_locale = LocalizationAutoload.get_current_locale()
	var font = LocalizationAutoload.get_font_for_locale(current_locale)
	
	#применяем шрифт если имеется
	if font:
		apply_pause_font(font)
	
	#обновляем текст кнопок паузы
	if title:
		title.text = LocalizationAutoload.get_text("pausemenu/title")
	if continue_btn:
		continue_btn.text = LocalizationAutoload.get_text("pausemenu/continue")
	if settings_btn:
		settings_btn.text = LocalizationAutoload.get_text("pausemenu/settings_pausemenu")
	if exit_btn:
		exit_btn.text = LocalizationAutoload.get_text("pausemenu/exit_to_menu")

func _on_language_changed(locale: String):
	update_ui_text()
	print("Язык паузы изменен на: ", locale)

func _input(event):
	if event.is_action_pressed("escape") and not is_pause_animation_playing:
		toggle_pause()

func toggle_pause():
	if get_tree().paused:
		resume_game()
	else:
		pause_game()

func pause_game():
	is_pause_animation_playing = true
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = true
	can_player_move = false
	var tween = create_tween().set_parallel(true)
	tween.tween_property(continue_btn, "position:x", 64, 0.9).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(settings_btn, "position:x", 64, 1.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(exit_btn, "position:x", 64, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(title, "position:x", 64, 0.9).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await tween.finished
	is_pause_animation_playing = false
	can_player_move = true

func resume_game():
	is_pause_animation_playing = true
	can_player_move = false
	var tween = create_tween().set_parallel(true)
	tween.tween_property(continue_btn, "position:x", -240, 0.7).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(settings_btn, "position:x", -376, 0.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(exit_btn, "position:x", -552, 0.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(title, "position:x", -744, 0.7).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await tween.finished
	visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	is_pause_animation_playing = false
	can_player_move = true

func _on_continue_pressed():
	if not is_pause_animation_playing:
		resume_game()

func _on_settings_pressed():
	print("потом добавлю отдельно")

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://assets/scenes/menu_scenes/menu.tscn")

func is_player_movement_allowed():
	return can_player_move and not is_pause_animation_playing and not get_tree().paused
