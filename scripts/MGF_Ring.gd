extends Node2D

signal ring_collected 
onready var rings = get_node("MGF_Ring")
onready var timer = $TimerRing

func _process(delta: float) -> void:
	position.y -= 425 * delta

func _on_MGF_Ring_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		emit_signal("ring_collected")
		rings.hide()

func _on_VisibilityNotifier2D_screen_exited() -> void:
	timer.start()

func _on_TimerRing_timeout() -> void:
	rings.show()
	position.x = rand_range(384,768)
	position.y = 784
	timer.wait_time = rand_range(10.0,20.0)
