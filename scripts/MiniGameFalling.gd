extends Node

var score = 0
onready var scorelabel = get_node("UI/Interface/CanvasLayer/RichTextLabel")
onready var rings = get_node("MGF_Ring")
onready var firstaid = get_node("MGF_FirstAid")
const mgf_wall = preload("res://scenes/MGF_Wall.tscn")
const mgf_bg = preload("res://scenes/MGF_BG.tscn")
const mgf_obstecles = preload("res://scenes/MGF_Obstecles.tscn")
const mgf_obsteclestiny = preload("res://scenes/MGF_ObsteclesTiny.tscn")
onready var obstecles_timer = $TimerObstecles
onready var obsteclestiny_timer = $TimerObsteclesTiny
onready var portal = get_node("MGF_NextLevel")
onready var portalclosing = get_node("NextLevelClosing")

func _ready() -> void:
	Global.mouse_cursor_hide()
	var track = load("res://audio/musicbg2.ogg")
	Global.musicbg.stream = track
	Global.musicbg.play()

func _process(delta: float) -> void:
	portal.position.y -= 183 * delta
	portalclosing.position.y -= 763 * delta

func _on_TimerWall_timeout() -> void:
	var add_mgf_walls = mgf_wall.instance()
	add_child(add_mgf_walls)

func _on_TimerBG_timeout() -> void:
	var add_mgf_bg = mgf_bg.instance()
	add_child(add_mgf_bg)

func _on_TimerObstecles_timeout() -> void:
	var add_mgf_obstecles = mgf_obstecles.instance()
	add_child(add_mgf_obstecles)
	obstecles_timer.wait_time = rand_range(1.0,2.0)

func _on_TimerObsteclesTiny_timeout() -> void:
	var add_mgf_obsteclestiny = mgf_obsteclestiny.instance()
	add_child(add_mgf_obsteclestiny)
	obsteclestiny_timer.wait_time = rand_range(4.4,8.8)

func _on_MGF_Ring_ring_collected() -> void:
	score = score + 1
	var scoretext = ""+String(score)
	scorelabel.clear()
	scorelabel.add_text(scoretext)
	if score >= 5:
		rings.queue_free()
		firstaid.queue_free()
		obstecles_timer.stop()
		obsteclestiny_timer.stop()
		portal.position.x = 640
		portal.position.y = 784
