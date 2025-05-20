class_name Enemy2
extends Actor

enum State {
	WALKING,
	DEAD
}
var _state = State.WALKING
onready var platform_detector = $PlatformDetector
onready var floor_detector_left = $FloorDetectorLeft
onready var floor_detector_right = $FloorDetectorRight
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

func _ready():
	_velocity.x = speed.x

func _physics_process(_delta):
	_velocity = calculate_move_velocity(_velocity)
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
	sprite.scale.x = 1 if _velocity.x > 0 else -1
	var animation = get_new_animation()
	if animation != animation_player.current_animation:
		animation_player.play(animation)
	if get_slide_count() > 0:
		for i in range (get_slide_count()):
			if "Player" in get_slide_collision(i).collider.name:
				get_slide_collision(i).collider.damage(34)

func calculate_move_velocity(linear_velocity):
	var velocity = linear_velocity
	if not floor_detector_left.is_colliding():
		velocity.x = speed.x
	elif not floor_detector_right.is_colliding():
		velocity.x = -speed.x
	if is_on_wall():
		velocity.x *= -1
	return velocity

func destroy():
	_state = State.DEAD
	_velocity = Vector2.ZERO
	speed.x = 0
	speed.y = 0
	$TimerDead.start()
	$AnimationPlayer.play("dead")

func get_new_animation():
	var animation_new = ""
	if _state == State.WALKING:
		animation_new = "walk" if abs(_velocity.x) > 0 else "idle"
	else:
		animation_new = "dead"
		$CollisionShape2D.disabled = true
	return animation_new

func _on_Hurtbox_area_entered(area: Area2D) -> void:
	if _state != State.DEAD and area.name == "PlayerAttackHitBox":
		destroy()
	pass

func _on_TimerDead_timeout() -> void:
	queue_free()
