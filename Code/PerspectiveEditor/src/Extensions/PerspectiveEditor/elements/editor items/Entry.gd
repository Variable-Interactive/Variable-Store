extends VBoxContainer

var main
var vanishing_point

var position = Vector2.ZERO
var angles = []
var radiai = []
var color :Color
var global

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Title/Label.text = str("Point: ",get_parent().get_child_count() - 2)
	color = Color(randf(), randf(), randf(), 0.9)
	$Title/Label.get_parent().color = color
	$PointInfo/ColorPickerButton.color = color
	$PointInfo/Delete/TextureRect.self_modulate = color
	$PointInfo/ColorPickerButton.connect("color_changed", self, "_on_color_changed")
	global = get_node_or_null("/root/Global")
	create(global)


func create(_global):
	if vanishing_point:
		vanishing_point.queue_free()

	vanishing_point = preload("res://src/Extensions/PerspectiveEditor/elements/canvas items/VanishingPoint.tscn").instance()
	vanishing_point.main = main
	vanishing_point.global = _global
	update_line_data()
	vanishing_point.initiate()


func update_line_data():
	vanishing_point.start = position
	vanishing_point.angles = angles
	vanishing_point.radiai = radiai
	vanishing_point.color = color


func _on_AddLine_pressed() -> void:
	add_line_button()
	vanishing_point.add_line()


func add_line_button():
	var line_options = preload("res://src/Extensions/PerspectiveEditor/elements/editor items/LineOption.tscn").instance()

	var properties = line_options.find_node("AcceptDialog")
	var line_button = line_options.find_node("Line")
	var remove_button = properties.add_button("Delete", false, "Delete")
	var angle_box = properties.find_node("AngleBox")
	var radius_box = properties.find_node("RadiusBox")


	get_node("HBoxContainer/Angles/HBoxContainer").add_child(line_options)
	var index = line_options.get_parent().get_child_count() - 2
	line_options.get_parent().move_child(line_options, index)

	line_button.text = str("Line", line_options.get_index() + 1)

	angle_box.connect("value_changed", self, "_angle_changed", [line_options])
	angles.append(angle_box.value)

	radius_box.connect("value_changed", self, "_radius_changed", [line_options])
	radiai.append(radius_box.value)

	remove_button.connect("pressed", self, "_remove_line", [line_options])


func _on_Delete_pressed() -> void:
	queue_free()


func _exit_tree() -> void:
	if vanishing_point:
		vanishing_point.queue_free()


func _on_color_changed(_color :Color):
	color = _color
	$Title/Label.get_parent().color = color
	$PointInfo/Delete/TextureRect.self_modulate = color
	create(global)


func _on_XValue_value_changed(value: float) -> void:
	position.x = value
	create(global)


func _on_YValue_value_changed(value: float) -> void:
	position.y = value
	create(global)


func _angle_changed(value: float, angle_box):
	var index = angle_box.get_index()
	angles[index] = value
	update_line_data()
	vanishing_point.change_radius_and_angle(index)


func _radius_changed(value: float, angle_box):
	var index = angle_box.get_index()
	radiai[index] = value
	update_line_data()
	vanishing_point.change_radius_and_angle(index)


func _remove_line(angle_box):
	var index = angle_box.get_index()
	vanishing_point.remove_line(index)
	angle_box.queue_free()

