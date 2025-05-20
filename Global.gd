extends Node

const UNIT_SIZE = 128
var mousecursor = load("res://assets/ui_mouse.png")
var mousecursorhide = load("res://assets/ui_mousehide.png")
onready var musicbg = $musicbg
var filepath = "res://Keybinds.ini"
var configfile
var keybinds = {}
const User_directory = "user://"
const Res_directory = "res://"
const Settings_Path = Res_directory + "Settings.cfg"
enum {LOAD_ERROR_COULDNT_OPEN, LOAD_SUCCESS}
var config = ConfigFile.new()
var Settings = {
	"DISPLAY": 
	{
		"HEIGHT" : 720,
		"WIDTH" :1280,
		"FullScreen":false,
		"Vsync":true
	},
	"AUDIO":
	{
		"MUTE" : false,
		"MUSIC": 100,
		"GENERAL":100,
		"SOUND_EFFECTS":100
	}
}

func mouse_cursor():
	Input.set_custom_mouse_cursor(mousecursor)

func mouse_cursor_hide():
	Input.set_custom_mouse_cursor(mousecursorhide)

func _ready() -> void:
	mouse_cursor()
	if _load_Settings() == LOAD_ERROR_COULDNT_OPEN :
		_save_Settings()
	_apply_Settings()
	configfile = ConfigFile.new()
	if configfile.load(filepath) == OK:
		for key in configfile.get_section_keys("KEYBINDS"):
			var key_value = configfile.get_value("KEYBINDS", key)
			if str(key_value) != "":
				keybinds[key] = key_value
			else:
				keybinds[key] = null
	else:
		get_tree().quit()
	set_game_binds()

func set_game_binds():
	for key in keybinds.keys():
		var value = keybinds[key]
		var actionlist = InputMap.get_action_list(key)
		if !actionlist.empty():
			InputMap.action_erase_event(key, actionlist[0])
		if value != null:
			var new_key = InputEventKey.new()
			new_key.set_scancode(value)
			InputMap.action_add_event(key, new_key)

func write_config():
	for key in keybinds.keys():
		var key_value = keybinds[key]
		if key_value != null:
			configfile.set_value("KEYBINDS", key, key_value)
		else:
			configfile.set_value("KEYBINDS", key, "")
	configfile.save(filepath)

func _load_Settings():
	var error = config.load(Settings_Path)
	if error != OK:
		return LOAD_ERROR_COULDNT_OPEN
	for section in Settings.keys():
		for key in Settings[section]:
			var val = config.get_value(section,key)
			Settings[section][key] = val
	return LOAD_SUCCESS

func _save_Settings():
	for section in Settings.keys():
		for key in Settings[section]:
			config.set_value(section,key,Settings[section][key])
	config.save(Settings_Path)

func _apply_Settings():
	OS.window_size = Vector2(Settings.DISPLAY.WIDTH,Settings.DISPLAY.HEIGHT)
	OS.window_fullscreen = Settings.DISPLAY.FullScreen
	OS.vsync_enabled = Settings.DISPLAY.Vsync

func update_Settings(H,W,Full,Audio,Mute,Vsync):
	Settings.DISPLAY.HEIGHT = H
	Settings.DISPLAY.WIDTH = W
	Settings.DISPLAY.FullScreen = Full
	Settings.DISPLAY.Vsync = Vsync
	Settings.AUDIO.GENERAL = Audio.x
	Settings.AUDIO.MUSIC = Audio.y
	Settings.AUDIO.SOUND_EFFECTS = Audio.z
	Settings.AUDIO.MUTE = Mute
	_save_Settings()
	_apply_Settings()

func _on_MusicVolumeSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
