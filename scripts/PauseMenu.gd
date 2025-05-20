extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause"):
		get_tree().paused = not get_tree().paused
		visible = not visible
	if get_tree().paused:
		Global.mouse_cursor()
	if not get_tree().paused:
		Global.mouse_cursor_hide()

func _on_ResumeButton_button_up() -> void:
	get_tree().paused = not get_tree().paused
	visible = not visible
	if get_tree().paused:
		Global.mouse_cursor()
	if not get_tree().paused:
		Global.mouse_cursor_hide()

func _on_QuitButton_button_up() -> void:
	get_tree().paused = not get_tree().paused
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/MainMenu.tscn")
