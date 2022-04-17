extends Node

var global :Node  #Needed for reference to "Global" node of Pixelorama (Used most of the time)
var averager :VBoxContainer
var left_col_pick :ColorPickerButton
var right_col_pick :ColorPickerButton

# This script acts as a setup for the extension
func _enter_tree() -> void:
	global = get_node("/root/Global")
	if global:
		var color_pickers: PanelContainer = global.control.find_node("Color Pickers")
		left_col_pick = color_pickers.get_node("ColorPickersHorizontal/LeftColorPickerButton")
		right_col_pick = color_pickers.get_node("ColorPickersHorizontal/RightColorPickerButton")

		averager = preload("res://src/Extensions/AverageColor/Elements/Averager.tscn").instance()
		color_pickers.get_node("ColorPickersHorizontal/ColorButtonsVertical").add_child(averager)
		right_col_pick.show_behind_parent = true
		averager.left_button = left_col_pick
		averager.right_button = right_col_pick


func _exit_tree() -> void:
	if global:
		if averager:
			averager.queue_free()
			right_col_pick.show_behind_parent = false
