extends CanvasLayer

@onready var transition_rect = $ColorRect
@onready var story_text = $"Pre-Story_Text"
@onready var line_edit = $LineEdit
@onready var confirm_button = $ConfirmButton

var story_lines = []
var player_name = ""

func _ready():
	#подключение к сигналу смены языка
	LocalizationAutoload.language_changed.connect(_on_language_changed)
	#апдейт интерфейса с текущим языком
	update_ui_text()
	
	$Title.position.y = -120;
	$startgame.position.x = -240
	$options.position.x = -280
	$credits.position.x = -336
	$quit.position.x = -368
	$flag_uk_button.position.y = 1168
	$flag_ru_button.position.y = 1168
	#изначально скрываем ноды
	if has_node("ColorRect"):
		transition_rect.visible = false
	if has_node("Pre-Story_Text"):
		story_text.visible = false
		story_text.modulate = Color(0, 0, 0, 1)
		story_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		story_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	#скрытие поле ввода и кнопку
	if has_node("LineEdit"):
		line_edit.visible = false
		line_edit.modulate = Color(1, 1, 1, 0)
	if has_node("ConfirmButton"):
		confirm_button.visible = false
		confirm_button.modulate = Color(1, 1, 1, 0)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property($Title, "position:y", 136, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($startgame, "position:x", 72, 1.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($options, "position:x", 72, 1.35).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($credits, "position:x", 64, 1.45).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($quit, "position:x", 72, 1.55).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($flag_uk_button, "position:y", 968, 1.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($flag_ru_button, "position:y", 968, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	#подключаем кнопки англ и ру
	if has_node("flag_uk_button"):
		$flag_uk_button.pressed.connect(_on_flag_uk_pressed)
	if has_node("flag_ru_button"):
		$flag_ru_button.pressed.connect(_on_flag_ru_pressed)

func apply_russian_font(font: Font):
	#применяем шрифт ко всему тексту
	$Title.add_theme_font_override("font", font)
	$startgame.add_theme_font_override("font", font)
	$options.add_theme_font_override("font", font)
	$credits.add_theme_font_override("font", font)
	$quit.add_theme_font_override("font", font)
	var input_font = LocalizationAutoload.get_input_font_for_locale(LocalizationAutoload.get_current_locale())
	if has_node("ConfirmButton") and input_font:
		$ConfirmButton.add_theme_font_override("font", input_font)
	if has_node("Pre-Story_Text") and input_font:
		$"Pre-Story_Text".add_theme_font_override("font", input_font)
	if has_node("LineEdit") and input_font:
		$LineEdit.add_theme_font_override("font", input_font)

func update_ui_text():
	var current_locale = LocalizationAutoload.get_current_locale()
	var font = LocalizationAutoload.get_font_for_locale(current_locale)
	if font:
		apply_russian_font(font)
	$Title.text = LocalizationAutoload.get_text("menu/title")
	$startgame.text = LocalizationAutoload.get_text("menu/start_game")
	$options.text = LocalizationAutoload.get_text("menu/settings")
	$credits.text = LocalizationAutoload.get_text("menu/credits")
	$quit.text = LocalizationAutoload.get_text("menu/quit")
	
	if has_node("ConfirmButton"):
		confirm_button.text = LocalizationAutoload.get_text("intro/confirm")
	if has_node("LineEdit"):
		line_edit.placeholder_text = LocalizationAutoload.get_text("intro/enter_name_placeholder")
	#обновляем текст для интро
	story_lines = [
		LocalizationAutoload.get_text("intro/hey"),
		LocalizationAutoload.get_text("intro/enter_name")
	]

func _on_language_changed(locale: String):
	update_ui_text()
	print("Язык изменен на: ", locale)

func _on_flag_uk_pressed():
	LocalizationAutoload.set_locale("en")

func _on_flag_ru_pressed():
	LocalizationAutoload.set_locale("ru")

func _on_start_game_pressed():
	#отключение кнопок после нажатия, чтобы не вызывать лишних багов
	$startgame.disabled = true
	$options.disabled = true
	$credits.disabled = true
	$quit.disabled = true
	#анимация ухода кнопок и текста
	var tween = create_tween().set_parallel(true)
	tween.tween_property($Title, "position:y", -1000, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($startgame, "position:x", -1500, 1.8).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($options, "position:x", -1500, 1.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($credits, "position:x", -1500, 1.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($quit, "position:x", -1500, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($flag_uk_button, "position:y", 1500, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($flag_ru_button, "position:y", 1500, 1.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.7).timeout
	#затемнение экрана
	if has_node("ColorRect"):
		transition_rect.visible = true
		transition_rect.color = Color(0, 0, 0, 0)
		var tween_darken = create_tween()
		if tween_darken:
			tween_darken.tween_property(transition_rect, "color", Color(0, 0, 0, 1), 0.8).set_ease(Tween.EASE_IN_OUT)
			await tween_darken.finished
	#последовательное появление текстов
	await show_story_sequence()

func show_story_sequence():
	if has_node("Pre-Story_Text"):
		story_text.visible = true
		for i in range(story_lines.size()):
			#текущий текст
			story_text.text = story_lines[i]
			story_text.modulate = Color(0, 0, 0, 1)
			#анимация появления текста
			var tween_text = create_tween()
			if tween_text:
				tween_text.tween_property(story_text, "modulate", Color(1, 1, 1, 1), 0.8).set_ease(Tween.EASE_IN_OUT)
				await tween_text.finished
			# текст с просьбой ввести имя - показываем поле ввода и кнопку
			if i == story_lines.size() - 1:
				await get_tree().create_timer(0.5).timeout
				show_input_elements()
				break
			else:
				#ожидание следующего текста
				await get_tree().create_timer(2.0).timeout
				#анимация исчезновения текста
				var tween_fade = create_tween()
				if tween_fade:
					tween_fade.tween_property(story_text, "modulate", Color(0, 0, 0, 1), 0.5).set_ease(Tween.EASE_IN_OUT)
					await tween_fade.finished

func show_input_elements():
	#показываем поле ввода и кнопку
	if has_node("LineEdit"):
		line_edit.visible = true
		line_edit.modulate = Color(1, 1, 1, 0)
	if has_node("ConfirmButton"):
		confirm_button.visible = true
		confirm_button.modulate = Color(1, 1, 1, 0)
	#плавное появление поля ввода и кнопки
	var tween_input = create_tween().set_parallel(true)
	if has_node("LineEdit"):
		tween_input.tween_property(line_edit, "modulate", Color(1, 1, 1, 1), 0.6).set_ease(Tween.EASE_IN_OUT)
	if has_node("ConfirmButton"):
		tween_input.tween_property(confirm_button, "modulate", Color(1, 1, 1, 1), 0.6).set_ease(Tween.EASE_IN_OUT)
	#фокусировка на поле ввода
	await get_tree().create_timer(0.5).timeout
	if has_node("LineEdit"):
		line_edit.grab_focus()

func _on_confirm_button_pressed():
	var input_name = line_edit.text.strip_edges()
	if input_name.length() > 0:
		player_name = input_name
		print("Имя персонажа сохранено: ", player_name)
		#плавное исчезновение текста, поля ввода и кнопки одновременно
		var tween_exit = create_tween().set_parallel(true)
		# Исчезновение текста
		if has_node("Pre-Story_Text"):
			tween_exit.tween_property(story_text, "modulate", Color(0, 0, 0, 1), 0.5).set_ease(Tween.EASE_IN_OUT)
		# Исчезновение поля ввода и кнопки
		if has_node("LineEdit"):
			tween_exit.tween_property(line_edit, "modulate", Color(1, 1, 1, 0), 0.5).set_ease(Tween.EASE_IN_OUT)
		if has_node("ConfirmButton"):
			tween_exit.tween_property(confirm_button, "modulate", Color(1, 1, 1, 0), 0.5).set_ease(Tween.EASE_IN_OUT)
		await tween_exit.finished
		#скрытие элементов
		if has_node("LineEdit"):
			line_edit.visible = false
		if has_node("ConfirmButton"):
			confirm_button.visible = false
		#финальный текст
		await show_final_message()
		#переход к игре
		get_tree().change_scene_to_file("res://assets/scenes/scenes_for_testing_anything/game_test.tscn")
	else:
		#анимация ошибки
		var tween_error = create_tween()
		if tween_error:
			tween_error.tween_property(line_edit, "modulate", Color(1, 0.5, 0.5, 1), 0.2)
			tween_error.tween_property(line_edit, "modulate", Color(1, 1, 1, 1), 0.2)

func show_final_message():
	if has_node("Pre-Story_Text"):
		story_text.text = LocalizationAutoload.get_text("intro/thanks")
		story_text.modulate = Color(0, 0, 0, 1)
		var tween_final = create_tween()
		if tween_final:
			tween_final.tween_property(story_text, "modulate", Color(1, 1, 1, 1), 0.8).set_ease(Tween.EASE_IN_OUT)
			await tween_final.finished
		await get_tree().create_timer(2.0).timeout

func get_player_name():
	return player_name

func _on_settings_pressed():
	FixGraphicSettings.last_scene = "menu"
	var tween = create_tween().set_parallel(true)
	if tween:
		tween.tween_property($Title, "position:y", -1000, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($startgame, "position:x", -1500, 1.8).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($options, "position:x", -1500, 1.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($credits, "position:x", -1500, 1.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($quit, "position:x", -1500, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($flag_uk_button, "position:y", 1500, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($flag_ru_button, "position:y", 1500, 1.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		await get_tree().create_timer(0.46).timeout
		get_tree().change_scene_to_file("res://assets/scenes/options_scenes/options.tscn")

func _on_quit_pressed():
	get_tree().quit()
