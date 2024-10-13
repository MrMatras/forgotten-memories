extends Control

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		pause_or_unpause()

func pause_or_unpause():
	var is_paused = get_tree().paused
	$PanelContainer/button_resume.visible = is_paused
	get_tree().paused = !is_paused
