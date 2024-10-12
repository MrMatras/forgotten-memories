extends Control

func _ready():
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")

func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func testEscape():
	if Input.is_action_just_pressed("escape") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused == true:
		resume()

func _on_button_resume_pressed():
	resume()

func _on_button_quit_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/menu.tscn")

func _process(delta):
	testEscape()
