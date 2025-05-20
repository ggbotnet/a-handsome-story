extends Area2D

signal egg_collected

func _on_EEG_Trigger_area_entered(area: Area2D) -> void:
	if area.name == "PlayerAttackHitBox":
		emit_signal("egg_collected")
		queue_free()
