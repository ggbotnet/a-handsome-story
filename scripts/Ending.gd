extends Control

func _ready() -> void:
	Global.mouse_cursor()
	Global.musicbg.stop()

func _on_BackButton_pressed() -> void:
	get_tree().change_scene("res://scenes/MainMenu.tscn")
