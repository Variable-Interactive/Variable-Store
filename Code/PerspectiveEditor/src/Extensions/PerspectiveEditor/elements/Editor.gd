extends Panel

var main :Node
var old_size :Vector2

func _on_AddPoint_pressed() -> void:
	var entry := preload("res://src/Extensions/PerspectiveEditor/elements/editor items/Entry.tscn").instance()
	entry.main = main
	$VBoxContainer/Panel/Content/VBoxContainer.add_child(entry)
	var index = $VBoxContainer/Panel/Content/VBoxContainer.get_child_count() - 2
	$VBoxContainer/Panel/Content/VBoxContainer.move_child(entry, index)


func _on_Visibility_toggled(button_pressed: bool) -> void:
	if button_pressed:
		$VBoxContainer/ColorRect/Visibility.text = "Maximize"
		old_size = rect_size
		rect_min_size = Vector2(150, 64)
		rect_size = rect_min_size
	else:
		$VBoxContainer/ColorRect/Visibility.text = "Minimize"
		rect_min_size = Vector2(375, 150)
		rect_size = old_size


func _on_Visibility_mouse_entered() -> void:
	$VBoxContainer/ColorRect/Visibility.disabled = false


func _on_Visibility_mouse_exited() -> void:
	$VBoxContainer/ColorRect/Visibility.disabled = true


#### Template Built-in Code for "Custom Dialog" movement and Scale
#### You don't have to touch anything below
var _global :Node  # Needed for reference to "Global" node of Pixelorama (Used most of the time)
var moving = false
var scaling = false
var can_scale = false
var mode = 0
var scale_left = false
var scale_right = false
var scale_up = false
var scale_down = false
enum Mode { NONE, LEFT, RIGHT, UP, DOWN, T_LEFT, T_RIGHT, B_LEFT, B_RIGHT }
var scale_limit = 5
var offset = Vector2.ZERO


func _on_Instructions_visibility_changed() -> void:  # Popup the dialog
	_global = get_node_or_null("/root/Global")
	if visible:
		set_global_position(OS.window_size/2.0 - rect_size/2.0)


func _on_Title_gui_input(event: InputEvent) -> void:  # Here's where the dragging is done
	if event is InputEventMouseButton:
		if event.pressed:
			moving = true
			offset = get_local_mouse_position()
		else:
			moving = false

	if event is InputEventMouseMotion:
		if moving:
			set_global_position(get_global_mouse_position() - offset)


func _on_Main_mouse_entered():
	can_scale = true


func _on_Main_mouse_exited() -> void:
	if !scaling:
		can_scale = false


func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		var mouse_pos = get_local_mouse_position()

		# Avoid canvas interaction if hovering above dialog
		if _global:
			if Rect2(Vector2.ZERO, rect_size).has_point(mouse_pos):
				_global.can_draw = false
			else:
				if _global.has_focus:
					_global.can_draw = true

		if event is InputEventMouseMotion and !scaling: # Set cursor and mode accordingly
			# Decide Scale direction
			scale_left = false
			scale_right = false
			scale_up = false
			scale_down = false
			if ((mouse_pos.x < scale_limit and mouse_pos.x > -scale_limit)
			and (mouse_pos.y > 0 and mouse_pos.y < rect_size.y)): #Left
				scale_left = true
			elif (mouse_pos.x >= rect_size.x - scale_limit and mouse_pos.x <= rect_size.x + scale_limit
			and (mouse_pos.y > 0 and mouse_pos.y < rect_size.y)): #Right
				scale_right = true
			if ((mouse_pos.y < scale_limit and mouse_pos.y > -scale_limit)
			and (mouse_pos.x > 0 and mouse_pos.x < rect_size.x)): #Up
				scale_up = true
			elif (mouse_pos.y >= rect_size.y - scale_limit and mouse_pos.y <= rect_size.y + scale_limit
			and (mouse_pos.x > 0 and mouse_pos.x < rect_size.x)): #Down
				scale_down = true

			# Decide Cursors
			if (scale_up and scale_left) or (scale_down and scale_right):
				mouse_default_cursor_shape = Control.CURSOR_FDIAGSIZE
			elif (scale_up and scale_right) or (scale_down and scale_left):
				mouse_default_cursor_shape = Control.CURSOR_BDIAGSIZE
			elif (scale_up or scale_down):
				mouse_default_cursor_shape = Control.CURSOR_VSIZE
			elif (scale_left or scale_right):
				mouse_default_cursor_shape = Control.CURSOR_HSIZE
			else:
				mouse_default_cursor_shape = Control.CURSOR_ARROW

		elif event is InputEventMouseMotion and scaling:  # Here's where the scaling is done
			if can_scale:
				# SIDES
				if scale_right:
					rect_size.x += get_global_mouse_position().x - rect_global_position.x - (rect_size.x)
				elif scale_left:
					if rect_size.x + (rect_global_position.x - get_global_mouse_position().x) > rect_min_size.x:
						rect_size.x += rect_global_position.x - get_global_mouse_position().x
						rect_position.x -= (rect_global_position.x) - get_global_mouse_position().x
				if scale_down:
					rect_size.y += get_global_mouse_position().y - rect_global_position.y - (rect_size.y)
				elif scale_up:
					if rect_size.y + (rect_global_position.y - get_global_mouse_position().y) > rect_min_size.y:
						rect_size.y += rect_global_position.y - get_global_mouse_position().y
						rect_position.y -= (rect_global_position.y) - get_global_mouse_position().y

		if event is InputEventMouseButton:
			if event.pressed:
				scaling = true
			else:
				scaling = false
				can_scale = false
				scale_left = false
				scale_right = false
				scale_up = false
				scale_down = false
