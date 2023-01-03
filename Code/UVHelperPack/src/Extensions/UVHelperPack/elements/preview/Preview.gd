extends Panel

var main :Node  # Used for communication between different extension elements

onready var hue_slider = $VBoxContainer/Settings/VBoxContainer/HVPreview/H/HSlider
onready var val_slider = $VBoxContainer/Settings/VBoxContainer/HVPreview/V/VSlider

onready var hue_spinbox = $VBoxContainer/Settings/VBoxContainer/HVPreview/H/HSpinBox
onready var val_spinbox = $VBoxContainer/Settings/VBoxContainer/HVPreview/V/VSpinBox

onready var main_title = $VBoxContainer/ColorRect/Title
onready var map_title = $VBoxContainer/Settings/VBoxContainer/MapPreview/Name
var map_texture := ImageTexture.new()


var view_mode :int = 0  # 0 for HV view, 1 for Map view

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/ColorRect.self_modulate = Color(0, 0, 0, 0.7)
	_hv_mode()



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


func _on_Preview_visibility_changed() -> void:  # Popup the dialog
	_global = get_node_or_null("/root/Global")
	if visible:
		set_global_position(OS.window_size/2.0 - rect_size/2.0)
		update_preview()


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

			if (
				(!_global.control.left_cursor.visible
				or !_global.control.right_cursor.visible)
			):
				_global.has_focus = false
			else:
				_global.has_focus = true

		elif event is InputEventMouseMotion and scaling:  # Here's where the scaling is done
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


func _on_Hue_value_changed(value: float) -> void:
	hue_spinbox.value = value
	hue_slider.value = value
	update_preview()


func _on_Value_value_changed(value: float) -> void:
	val_spinbox.value = value
	val_slider.value = value
	update_preview()


func update_preview():
	var params := {}
	if view_mode == 0:
		params = {
			"hue_shift_amount": hue_slider.value / 360,
			"sat_shift_amount": 0,
			"val_shift_amount": val_slider.value / 100,
		}
	elif view_mode == 1:
		var size = Vector2.ONE # the default value
		if !map_texture.get_data(): # if there's no image loaded
			var img := Image.new()
			img.create(1, 1, false, Image.FORMAT_ETC2_RGBA8)
			map_texture.create_from_image(img, 0)

		size = map_texture.get_data().get_size()
		params = {
			"map_texture": map_texture,
			"map_size": size
		}
	for param in params:
		material.set_shader_param(param, params[param])

	main.global.dialog_open(false)


func _hv_mode():
	$VBoxContainer/Settings/VBoxContainer/MapPreview.visible = false
	$VBoxContainer/Settings/VBoxContainer/HVPreview.visible = true
	var sm = ShaderMaterial.new()
	sm.shader = preload("res://src/Extensions/UVHelperPack/elements/preview/HV.gdshader")
	material = sm
	main_title.text = "Hue/Value Preview"
	main_title.hint_tooltip = """Hover this over the drawing to view it in Hue/Value Mode
Colors near black are hard to differentiate so use this preview (you can scale this preview from corners)"""
	view_mode = 0
	update_preview()


func _map_view():
	$VBoxContainer/Settings/VBoxContainer/HVPreview.visible = false
	$VBoxContainer/Settings/VBoxContainer/MapPreview.visible = true
	var sm = ShaderMaterial.new()
	sm.shader = preload("res://src/Extensions/UVHelperPack/elements/preview/Map.gdshader")
	material = sm
	main_title.text = "Map view"
	main_title.hint_tooltip = """Hover this over the drawing to view it in Maper Mode
Use this to view the final result after "Image-> Apply Map" (you can scale this preview from corners)"""
	view_mode = 1
	update_preview()


func _on_OptionButton_item_selected(index: int) -> void:
	if index == 0:
		_hv_mode()
	else:
		_map_view()


func _on_Load_pressed() -> void:
	var maploader = main.apply_dialog.get_node("MapLoader")
	var opensave = get_node_or_null("/root/OpenSave")
	var global = main.global

	maploader.popup(Rect2(self.rect_position, maploader.rect_size))
	if opensave:
		var save_path = opensave.current_save_paths[global.current_project_index]
		maploader.current_path = save_path

	global.dialog_open(true)


func _on_PreviewPanel_mouse_entered() -> void:
	var global = main.global
	global.control.left_cursor.visible = global.show_left_tool_icon
	global.control.right_cursor.visible = global.show_right_tool_icon


func _on_PreviewPanel_mouse_exited() -> void:
	var global = main.global
	global.control.left_cursor.visible = false
	global.control.right_cursor.visible = false
