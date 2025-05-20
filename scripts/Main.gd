extends Node2D

var score = 0
var eggscore = 0
onready var scorelabel = get_node("UI/Interface/CanvasLayer/RichTextLabel")
onready var dialogboxunlock = get_node("UI/DialogUnlock")
onready var timerdialogunlock = $UI/TimerDialogUnlock
onready var effect_darkness_mask = get_node("EffectDarkness/CanvasDark/MaskDarkness")
onready var effect_darkness_anim = get_node("EffectDarkness/AnimationPlayer")
onready var timer_dark_on = $TimerDarknessON
onready var timer_dark_off = $TimerDarknessOFF
onready var eeg_cthulhu = $EEG_Cthulhu

func _on_Ring_ring_collected() -> void:
	score = score + 1
	var scoretext = ""+String(score)
	scorelabel.clear()
	scorelabel.add_text(scoretext)
	var cage_move_up = get_node("LevelPortal/Lvl_Locker")
	if score >= 5:
		cage_move_up.position.y = -256
		dialogboxunlock.get_child(0).show()
		TimerDialogUnlockRun()

func _on_EEG_Trigger_egg_collected() -> void:
	eggscore = eggscore + 1
	var eggscoretext = ""+String(eggscore)
	if eggscore >= 3: #3
		eeg_cthulhu.get_child(0).show()
		eeg_cthulhu.set_collision_mask(1)
		pass

func _ready() -> void:
	Global.mouse_cursor_hide()
	var track = load("res://audio/musicbg.ogg")
	Global.musicbg.stream = track
	Global.musicbg.play()

func dialog_gamerule():
	var dialogbox = get_node("UI/DialogGameRule")
	dialogbox.get_child(0).hide()
	pass

func _on_TimerDialog_timeout() -> void:
	dialog_gamerule()

func TimerDialogUnlockRun():
	if timerdialogunlock.is_stopped():
		timerdialogunlock.start()

func _on_TimerDialogShow_timeout() -> void:
	dialogboxunlock.get_child(0).hide()

func _on_EEG_Cthulhu_draw() -> void:
	eeg_cthulhu.get_child(0).hide()
	eeg_cthulhu.set_collision_mask(0)

func _on_EffectDarkness_draw() -> void:
	effect_darkness_mask.hide()

func _on_DarknessON_body_entered(body: Node) -> void:
	$DarknessON.set_collision_mask(0)
	timer_dark_on.start()

func _on_DarknessOFF_body_entered(body: Node) -> void:
	$DarknessON.set_collision_mask(1)
	effect_darkness_anim.play("dark_off")
	timer_dark_off.start()

func _on_TimerDarknessON_timeout() -> void:
	effect_darkness_anim.play("dark_on")
	effect_darkness_mask.show()

func _on_TimerDarknessOFF_timeout() -> void:
	effect_darkness_mask.hide()
