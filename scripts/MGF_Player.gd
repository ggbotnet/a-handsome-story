class_name MGF_Player
extends KinematicBody2D

const MOTION_SPEED = 300
signal health_updated(health)
signal killed()
export (float) var max_health = 100
onready var health = max_health setget _set_health
onready var invulnerability_timer = $InvulnerabilityTimer
onready var heal_timer = $TimerHeal
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var animation_damage = $AnimationDamage
onready var game_over = $CanvasLayer/GameOver
onready var pause_menu = $CanvasLayer/PauseMenu
var is_dead = false

func _ready() -> void:
	animation_player.play("falling")
	$Timer.start()

func _physics_process(_delta):
	if is_dead == false:
		var direction = get_direction()
		if direction.x != 0:
			sprite.scale.x = 1 if direction.x > 0 else -1
		var motion = Vector2.ZERO
		self.transform.origin.y = 448
		motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		motion.y = 0
		motion = motion.normalized() * MOTION_SPEED
		#warning-ignore:return_value_discarded
		move_and_slide(motion)
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "MGF_Obstecles" in get_slide_collision(i).collider.name:
					damage(34)
				if "MGF_ObsteclesTiny" in get_slide_collision(i).collider.name:
					damage(34)

func get_direction():
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), -1 
	)

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

func _on_MGF_FirstAid_health_pickup() -> void:
	healup(100)
	if heal_timer.is_stopped():
		heal_timer.start()
		animation_damage.play("healup")
	if health == 100:
		$"../UI/Interface/CanvasLayer/Finger_1".show()
		$"../UI/Interface/CanvasLayer/Finger_2".show()

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
