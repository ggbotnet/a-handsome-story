extends Area2D

signal health_pickup

func _on_FirstAid_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		emit_signal("health_pickup")
		queue_free()
