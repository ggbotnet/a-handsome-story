extends StaticBody2D

func destroy():
	$Timer.start()
	$AnimationPlayer.play("broke")

func _on_DestructibleArea_area_entered(area: Area2D) -> void:
	if area.name == "PlayerAttackHitBox":
		destroy()
	pass

func _on_Timer_timeout() -> void:
	queue_free()
