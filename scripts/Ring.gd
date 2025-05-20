extends Area2D

signal ring_collected 

func _on_Ring_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		emit_signal("ring_collected")
		queue_free()
