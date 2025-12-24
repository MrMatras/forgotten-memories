extends Node

var current_locale = "en"
var translations = {}
var russian_font = preload("res://assets/fonts/vcrosdmono_rus.ttf")
var menu_fonts = {
	"en": preload("res://assets/fonts/VCR_OSD_MONO_1.001.ttf"),
	"ru": preload("res://assets/fonts/vcrosdmono_rus.ttf")
}
var input_fonts = {
	"en": preload("res://assets/fonts/selawkl.ttf"),
	"ru": preload("res://assets/fonts/selawkl.ttf")
}
var pause_fonts = {
	"en": preload("res://assets/fonts/VCR_OSD_MONO_1.001.ttf"),
	"ru": preload("res://assets/fonts/vcrosdmono_rus.ttf")
}
var audio_fonts = {
	"en": preload("res://assets/fonts/VCR_OSD_MONO_1.001.ttf"),
	"ru": preload("res://assets/fonts/vcrosdmono_rus.ttf")
}
var graphics_fonts = {
	"en": preload("res://assets/fonts/VCR_OSD_MONO_1.001.ttf"),
	"ru": preload("res://assets/fonts/vcrosdmono_rus.ttf")
}

signal language_changed(locale)

func _ready():
	load_translations()

func load_translations():
	var locales = ["en", "ru"]
	
	for locale in locales:
		var file_path = "res://assets/localization/%s.json" % locale
		var file = FileAccess.open(file_path, FileAccess.READ)
		
		if file:
			var content = file.get_as_text()
			file.close()
			
			var json = JSON.new()
			var error = json.parse(content)
			
			if error == OK:
				translations[locale] = json.data
			else:
				push_error("JSON parse error in %s: %s" % [file_path, json.get_error_message()])
		else:
			push_error("Failed to load translation file: " + file_path)

func set_locale(locale: String):
	if locale in translations:
		current_locale = locale
		language_changed.emit(locale)
		get_tree().call_group("localizable", "update_localization")
	else:
		push_error("Locale not found: " + locale)

func get_current_locale() -> String:
	return current_locale

func get_available_locales() -> Array:
	return translations.keys()

func get_text(key: String) -> String:
	var keys = key.split("/")
	var current_dict = translations.get(current_locale, {})
	
	for k in keys:
		if current_dict is Dictionary and k in current_dict:
			current_dict = current_dict[k]
		else:
			current_dict = translations.get("en", {})
			for k_fallback in keys:
				if current_dict is Dictionary and k_fallback in current_dict:
					current_dict = current_dict[k_fallback]
				else:
					return key
			break
	
	return str(current_dict)

func get_font_for_locale(locale: String):
	return menu_fonts.get(locale, menu_fonts["en"])

func get_pause_font_for_locale(locale: String):
	return pause_fonts.get(locale, pause_fonts["en"])

func get_input_font_for_locale(locale: String):
	return input_fonts.get(locale, input_fonts["en"])
