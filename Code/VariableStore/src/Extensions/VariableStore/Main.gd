extends Node

### Usage:
### Change the "store_link" and "download_file" variables from the (store.gd)
### Don't touch anything else


var global :Node  #Needed for reference to "Global" node of Pixelorama (Used most of the time)

var extension_container :VBoxContainer
var store :Button
# This script acts as a setup for the extension
func _enter_tree() -> void:
	global = get_node_or_null("/root/Global")
	if global:
		extension_container = global.control.find_node("Extensions")
		if extension_container:
			store = preload("res://src/Extensions/VariableStore/Store/Store.tscn").instance()
			store.get_child(0).extension_container = extension_container
			var parent = extension_container.get_node("HBoxContainer")
			parent.add_child(store)

func _exit_tree() -> void:
	store.queue_free()
