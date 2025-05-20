extends Area2D

onready var animation_player = $AnimationPlayer

func _ready() -> void:
	animation_player.play("rolling")

func _on_MGF_NextLevel_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene("res://scenes/Level_3.tscn")
