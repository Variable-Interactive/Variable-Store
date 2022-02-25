extends VBoxContainer

var moving := false
var offset := Vector2.ZERO


func _ready() -> void:
	get_parent().set_global_position(OS.window_size/2.0 - rect_size/2.0)


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


func _on_Title_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			moving = true
			offset = $Title.get_local_mouse_position()
		else:
			moving = false

	if event is InputEventMouseMotion:
		if moving:
			get_parent().set_global_position(get_global_mouse_position() - offset)
