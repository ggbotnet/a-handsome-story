extends Area2D

onready var game_over = $CanvasLayer/GameOver
onready var pause_menu = $CanvasLayer/PauseMenu

func _on_AreaDead_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		$TimerDead.start()

func _on_TimerDead_timeout() -> void:
	game_over.show()
	pause_menu.queue_free()
	get_tree().paused = not get_tree().paused
	visible = not visible
	if get_tree().paused:
		Global.mouse_cursor()
	if not get_tree().paused:
		Global.mouse_cursor_hide()
