extends Node

var global :Node  # Needed for reference to "Global" node of Pixelorama (Used most of the time)
var instructions_dialog  # Its a kind of "Custom Dialog" i designed myself

# This script acts as a setup for the extension
func _enter_tree() -> void:
	global = get_node_or_null("/root/Global")
	if global:
		var parent = global.control.get_node("Dialogs")
		instructions_dialog = preload("res://src/Extensions/Example/elements/Instructions.tscn").instance()
		parent.call_deferred("add_child", instructions_dialog)
		instructions_dialog.show()


func _exit_tree() -> void:
	if global:
		instructions_dialog.queue_free()
