extends Control

@onready var option_button = $HBoxContainer/OptionButton as OptionButton

const RESOLUTION_DICTIONARY : Dictionary = {
	"1920х1080" : Vector2i(1920, 1080),
	"1280x720" : Vector2i(1280, 720),
	"800х600" : Vector2i(800, 600)
}

func _ready():
	add_resolution_items()
	option_button.item_selected.connect(on_resolution_selected)
	

func add_resolution_items() -> void:
	for resolution_size_text in RESOLUTION_DICTIONARY:
		option_button.add_item(resolution_size_text)


func on_resolution_selected(index : int) -> void:
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
