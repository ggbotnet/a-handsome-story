extends Control

onready var buttoncontainer = get_node("TabContainer/Controls/VBoxContainer")
onready var buttonscript = load("res://scripts/KeyButton.gd")
var keybinds
var buttons = {}
var DISPLAY = {"h" : 0,"w":0}
var Audio = Vector3()
var String_spliter
var Muted 
var fullscreen
var Vsync

func _ready() -> void:
	Global.mouse_cursor()
	_update_settings()
	keybinds = Global.keybinds.duplicate()
	for key in keybinds.keys():
		var hbox = HBoxContainer.new()
		var label = Label.new()
		var button = Button.new()
		hbox.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		label.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		button.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		label.text = key
		var button_value = keybinds[key]
		if button_value != null:
			button.text = OS.get_scancode_string(button_value)
		else:
			button.text = "Unassigned"
		button.set_script(buttonscript)
		button.key = key
		button.value = button_value
		button.menu = self
		button.toggle_mode = true
		button.focus_mode = Control.FOCUS_NONE
		hbox.add_child(label)
		hbox.add_child(button)
		buttoncontainer.add_child(hbox)
		buttons[key] = button

func change_bind(key, value):
	keybinds[key] = value
	for k in keybinds.keys():
		if k != key and value != null and keybinds[k] == value:
			keybinds[k] = null
			buttons[k].value = null
			buttons[k].text = "Unassigned"

func _update_settings():
	get_node("TabContainer/Video/VBox/CB_FS").pressed = Global.Settings.DISPLAY.FullScreen
	get_node("TabContainer/Video/VBox/CB_Vsync").pressed = Global.Settings.DISPLAY.Vsync
	get_node("TabContainer/Audio/VBox/CB_Mute").pressed = Global.Settings.AUDIO.MUTE 
	get_node("TabContainer/Audio/VBox/HS_General").value = Global.Settings.AUDIO.GENERAL
	get_node("TabContainer/Audio/VBox/HS_Music").value = Global.Settings.AUDIO.MUSIC
	get_node("TabContainer/Audio/VBox/HS_SE").value = Global.Settings.AUDIO.SOUND_EFFECTS
	DISPLAY.h = Global.Settings.DISPLAY.HEIGHT
	DISPLAY.w = Global.Settings.DISPLAY.WIDTH
	Muted = get_node("TabContainer/Video/VBox/CB_FS").pressed 
	fullscreen = get_node("TabContainer/Audio/VBox/CB_Mute").pressed
	Audio = Vector3(Global.Settings.AUDIO.GENERAL,Global.Settings.AUDIO.MUSIC,Global.Settings.AUDIO.SOUND_EFFECTS)
	Vsync = Global.Settings.DISPLAY.Vsync
	_check_resolution()

func _check_resolution():
	var NB = get_node("TabContainer/Video/VBox/Option_Resolution").get_item_count()
	for i in NB:
		String_spliter = get_node("TabContainer/Video/VBox/Option_Resolution").get_item_text(i)
		String_spliter = String_spliter.split("x")
		if String_spliter[1] == String(Global.Settings.DISPLAY.HEIGHT) && String_spliter[0] == String(Global.Settings.DISPLAY.WIDTH):
			get_node("TabContainer/Video/VBox/Option_Resolution").select(i)

func _on_SaveButton_pressed() -> void:
	Global.update_Settings(DISPLAY.h,DISPLAY.w,fullscreen,Audio,Muted,Vsync)
	Global.keybinds = keybinds.duplicate()
	Global.set_game_binds()
	Global.write_config()

func _on_BackButton_button_up() -> void:
	get_tree().change_scene("res://scenes/MainMenu.tscn")

func _on_CB_FS_toggled(button_pressed: bool) -> void:
	fullscreen = button_pressed

func _on_Option_Resolution_item_selected(id: int) -> void:
	String_spliter = get_node("TabContainer/Video/VBox/Option_Resolution").get_item_text(id)
	String_spliter = String_spliter.split("x")
	DISPLAY.h = String_spliter[1]
	DISPLAY.w = String_spliter[0]

func _on_CB_Vsync_toggled(button_pressed: bool) -> void:
	Vsync = button_pressed

func _on_HS_General_value_changed(value: float) -> void:
	Audio.x = value

func _on_HS_Music_value_changed(value: float) -> void:
	Audio.y = value

func _on_HS_SE_value_changed(value: float) -> void:
	Audio.z = value

func _on_CB_Mute_toggled(button_pressed: bool) -> void:
	Muted = button_pressed
