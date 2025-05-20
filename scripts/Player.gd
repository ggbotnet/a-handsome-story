class_name Player
extends Actor

const FLOOR_DETECT_DISTANCE = 20.0
export(String) var action_suffix = ""
signal health_updated(health)
signal killed()
export (float) var max_health = 100
onready var health = max_health setget _set_health
onready var invulnerability_timer = $InvulnerabilityTimer
onready var heal_timer = $TimerHeal
onready var platform_detector = $PlatformDetector
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var animation_damage = $AnimationDamage
onready var shoot_timer = $AttackAnimation
onready var game_over = $CanvasLayer/GameOver
onready var pause_menu = $CanvasLayer/PauseMenu
var is_dead = false

func _ready():
	var camera: Camera2D = $Camera
	if action_suffix == "_p1":
		camera.custom_viewport = $"../.."
	elif action_suffix == "_p2":
		var viewport: Viewport = $"../../../../ViewportContainer2/Viewport"
		viewport.world_2d = ($"../.." as Viewport).world_2d
		camera.custom_viewport = viewport

func _physics_process(_delta):
	if is_dead == false:
		var direction = get_direction()
		var is_jump_interrupted = Input.is_action_just_pressed("jump" + action_suffix) and _velocity.y < 0.0
		_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
		var snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE if direction.y == 0.0 else Vector2.ZERO
		var is_on_platform = platform_detector.is_colliding()
		_velocity = move_and_slide_with_snap(
			_velocity, snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
		)
		if direction.x != 0:
			sprite.scale.x = 1 if direction.x > 0 else -1
		var is_shooting = false
		if Input.is_action_just_pressed("attack" + action_suffix):
			is_shooting = sprite
		var animation = get_new_animation(is_shooting)
		if animation != animation_player.current_animation and shoot_timer.is_stopped():
			if is_shooting:
				shoot_timer.start()
			animation_player.play(animation)
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Enemy" in get_slide_collision(i).collider.name:
					damage(34)

func get_direction():
	return Vector2(
		Input.get_action_strength("move_right" + action_suffix) - Input.get_action_strength("move_left" + action_suffix),
		-1 if is_on_floor() and Input.is_action_just_pressed("jump" + action_suffix) else 0
	)

func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		velocity.y = 0.0
	return velocity

func get_new_animation(is_shooting = false):
	var animation_new = ""
	if is_on_floor():
		animation_new = "walk" if abs(_velocity.x) > 0.1 else "idle"
	else:
		animation_new = "jump" if _velocity.y > 0 else "jump"
	if is_shooting:
		animation_new += "_weapon"
	return animation_new

func damage(amount):
	var amount_damaged = 0
	if invulnerability_timer.is_stopped():
		invulnerability_timer.start()
		var prev_health = health
		_set_health(health - amount)
		amount_damaged = prev_health - health
		emit_signal("damaged", amount)
		animation_damage.play("damage")
		if health != 0:
			animation_damage.queue("immunity")
	return amount_damaged

func healup(amount):
	_set_health(health + amount)

func _on_FirstAid_health_pickup() -> void:
	healup(100)
	if heal_timer.is_stopped():
		heal_timer.start()
		animation_damage.play("healup")
	if health == 100:
		$"../UI/Interface/CanvasLayer/Finger_1".show()
		$"../UI/Interface/CanvasLayer/Finger_2".show()
	pass

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			animation_player.stop()
			animation_damage.stop()
			$AnimationDead.play("dying")
			dead()
			emit_signal("killed")
		if health == 100:
			print("100 HP")
		if health == 66:
			$"../UI/Interface/CanvasLayer/Finger_1".hide()
		if health == 32:
			$"../UI/Interface/CanvasLayer/Finger_2".hide()

func dead():
	is_dead = true
	_velocity = Vector2.ZERO
	$TimerDead.start()

func _on_TimerDead_timeout() -> void:
	game_over.show()
	pause_menu.queue_free()
	get_tree().paused = not get_tree().paused
	visible = not visible
	if get_tree().paused:
		Global.mouse_cursor()
	if not get_tree().paused:
		Global.mouse_cursor_hide()

func _on_InvulnerabilityTimer_timeout() -> void:
	animation_damage.play("rest")

func _on_TimerHeal_timeout() -> void:
	animation_damage.play("rest")
