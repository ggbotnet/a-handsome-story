extends Control

func _on_RestartButton_pressed() -> void:
	get_tree().reload_current_scene()
	get_tree().paused = false

func _on_QuitButton_pressed() -> void:
	get_tree().change_scene("res://scenes/MainMenu.tscn")
	get_tree().paused = false
