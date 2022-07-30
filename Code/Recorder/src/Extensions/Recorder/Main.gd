extends Node

var extension_api :Node  # Needed for reference to "ExtensionsApi" node of Pixelorama (Used most of the time)

var movie_dialog :WindowDialog
# This script acts as a setup for the extension
func _enter_tree() -> void:
	extension_api = get_node_or_null("/root/ExtensionsApi")
	if extension_api:
		var dialog_parent = extension_api.get_global().control.get_node("Dialogs")
		movie_dialog = preload("res://src/Extensions/Recorder/Dialog/Dialog.tscn").instance()
		movie_dialog.extension_api = extension_api
		dialog_parent.call_deferred("add_child", movie_dialog)
		movie_dialog.get_close_button().visible = false


func _exit_tree() -> void:
	if extension_api:
		movie_dialog.queue_free()
