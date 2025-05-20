class_name MGF_Obstecles
extends StaticBody2D

var obstecles_list = ["obstecle01", "obstecle02"]

func _ready() -> void:
	randomize()
	var current_obstecle = obstecles_list[randi() % obstecles_list.size()]
	$AnimatedSprite.animation = current_obstecle
	position.x = rand_range(384,768)

func _process(delta: float) -> void:
	position.y += 383 * delta

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
