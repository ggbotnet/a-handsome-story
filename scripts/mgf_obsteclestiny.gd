class_name MGF_ObsteclesTiny
extends StaticBody2D

func _ready() -> void:
	position.x = rand_range(384,768)

func _process(delta: float) -> void:
	position.y += 300 * delta

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
