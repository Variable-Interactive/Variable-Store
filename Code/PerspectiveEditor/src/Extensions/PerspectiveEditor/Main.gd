extends Node

var global :Node  # Needed for reference to "Global" node of Pixelorama (Used most of the time)
var editor_dialog  # Its a kind of "Custom Dialog" i designed myself

var axes :Node2D

# This script acts as a setup for the extension
func _enter_tree() -> void:
	global = get_node_or_null("/root/Global")
	if global:
		var parent = global.control.get_node("Dialogs")
		editor_dialog = preload("res://src/Extensions/PerspectiveEditor/elements/Editor.tscn").instance()
		editor_dialog.main = self
		parent.call_deferred("add_child", editor_dialog)
		editor_dialog.show()

		axes = preload("res://src/Extensions/PerspectiveEditor/elements/editor items/Axes.tscn").instance()
		axes.get_child(0).global = global
		axes.get_child(1).global = global
		global.canvas.add_child(axes)


func _exit_tree() -> void:
	if global:
		editor_dialog.queue_free()
		axes.queue_free()