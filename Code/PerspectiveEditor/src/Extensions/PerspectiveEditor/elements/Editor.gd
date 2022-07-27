extends WindowDialog

var main :Node
var old_size :Vector2


func _ready() -> void:
	_global = get_node_or_null("/root/Global")
	get_close_button().visible = false
	set_global_position(OS.window_size/2.0 - rect_size/2.0)
	show()


func _on_AddPoint_pressed() -> void:
	var entry := preload("res://src/Extensions/PerspectiveEditor/elements/editor items/Entry.tscn").instance()
	entry.main = main
	$VBoxContainer/Panel/Content/VBoxContainer.add_child(entry)
	var index = $VBoxContainer/Panel/Content/VBoxContainer.get_child_count() - 2
	$VBoxContainer/Panel/Content/VBoxContainer.move_child(entry, index)


func _on_Visibility_toggled(button_pressed: bool) -> void:
	if button_pressed:
		$VBoxContainer/Visibility.text = "Maximize"
		old_size = rect_size
		rect_min_size = Vector2(164, 42)
		$VBoxContainer/Panel.visible = false
		rect_size = rect_min_size
	else:
		$VBoxContainer/Visibility.text = "Minimize"
		rect_min_size = Vector2(375, 150)
		$VBoxContainer/Panel.visible = true
		rect_size = old_size


func _on_Visibility_mouse_entered() -> void:
	$VBoxContainer/Visibility.disabled = false


func _on_Visibility_mouse_exited() -> void:
	$VBoxContainer/Visibility.disabled = true


#### You don't have to touch anything below
var _global :Node  # Needed for reference to "Global" node of Pixelorama (Used most of the time)


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
