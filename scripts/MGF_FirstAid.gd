extends Node2D

signal health_pickup
onready var firstaid = get_node("MGF_FirstAid")
onready var timer = $TimerFirstAid

func _process(delta: float) -> void:
	position.y -= 467 * delta

func _on_MGF_FirstAid_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		emit_signal("health_pickup")
		firstaid.hide()

func _on_VisibilityNotifier2D_screen_exited() -> void:
	timer.start()

func _on_TimerFirstAid_timeout() -> void:
	firstaid.show()
	position.x = rand_range(384,768)
	position.y = 784
	timer.wait_time = rand_range(6.0,18.0)
