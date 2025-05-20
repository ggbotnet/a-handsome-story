extends Button

var key
var value
var menu
var waitting_input = false

func _input(event: InputEvent) -> void:
	if waitting_input:
		if event is InputEventKey:
			value = event.scancode
			text = OS.get_scancode_string(value)
			menu.change_bind(key, value)
			pressed = false
			waitting_input = false
		if event is InputEventMouseButton:
			if value != null:
				text = OS.get_scancode_string(value)
			else:
				text = "Unassigned"
			pressed = false
			waitting_input = false

func _toggled(button_pressed: bool) -> void:
	if button_pressed:
		waitting_input = true
		set_text("Press Any Key")
