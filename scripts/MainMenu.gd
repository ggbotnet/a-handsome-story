extends Control

func _ready() -> void:
	Global.mouse_cursor()
	Global.musicbg.stop()

func _on_NewGameButton_button_up() -> void:
	get_tree().change_scene("res://scenes/Level_1.tscn")

func _on_OptionsButton_button_up() -> void:
	get_tree().change_scene("res://scenes/MainOptions.tscn")

func _on_ExitButton_button_up() -> void:
	get_tree().quit()
