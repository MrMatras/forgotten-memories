extends CanvasLayer

@onready var fps_label = $fps_label

func _process(_delta):
	if fps_label.visible:
		fps_label.text = "FPS: %d" % Engine.get_frames_per_second()

func set_visible_fps(show: bool):
	fps_label.visible = show
