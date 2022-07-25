extends VBoxContainer

var global :Node


func _ready() -> void:
	global = get_node_or_null("/root/Global")



func _on_Line_pressed() -> void:
	$Control/AcceptDialog.popup(Rect2(rect_global_position, $Control/AcceptDialog.rect_size))
	if global:
		global.dialog_open(true)


func _on_AcceptDialog_popup_hide() -> void:
	if global:
		global.dialog_open(false)


func _on_RadiusSlider_value_changed(value: float) -> void:
	$Control/AcceptDialog/Control/Radius/RadiusBox.value = value


func _on_AngleSlider_value_changed(value: float) -> void:
	$Control/AcceptDialog/Control/Angle/AngleBox.value = value
