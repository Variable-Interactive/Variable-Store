extends WindowDialog


func _ready() -> void:
	get_close_button().visible = false
	set_global_position(OS.window_size/2.0 - rect_size/2.0)
	show()


func _input(event: InputEvent) -> void:
	var old = $Panel/VBoxContainer/HBoxContainer/Panel/Label
	var mouse_buttons = $Panel/VBoxContainer/HBoxContainer/Mouse/VBoxContainer/HBoxContainer
	var key = ""
	if event is InputEventKey:
		if event.pressed:

			var next = OS.get_scancode_string(event.physical_scancode)
			if old.text != "":
				if !old.text.ends_with(str(next)):
					key = str(old.text, " + ", next)
				else:
					return
			else:
				key = str(next)
		old.text = str(key)

	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == BUTTON_LEFT:
				mouse_buttons.get_node("Left").color = Color.black
			elif event.button_index == BUTTON_RIGHT:
				mouse_buttons.get_node("Right").color = Color.black
			elif event.button_index == BUTTON_MIDDLE:
				mouse_buttons.get_node("Middle").color = Color.black
		else:
			mouse_buttons.get_node("Left").color = Color.white
			mouse_buttons.get_node("Right").color = Color.white
			mouse_buttons.get_node("Middle").color = Color.white


func _exit_tree() -> void:
	queue_free()
