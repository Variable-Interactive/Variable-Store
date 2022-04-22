extends Node

#### Usage:
### Change the "EXTENSION_NAME" and "STORE_LINK" to your choice
### and the version number is set from "extension.json" (version MUST be a float)
### Don't touch anything else
const STORE_LINK: String = "https://raw.githubusercontent.com/Variable-ind/Pixelorama-Extensions/master/store_info.txt"
const EXTENSION_NAME: String = "VariableStore"  # Should be the same as the extension name in extension.json
### Principle/Setup:
#  1) Make a file in the repository and store all the extensions inside it in
#     the form of
#     ["Name", "Information", "Image", "Download Link"]
#     -> Name          : The EXACT case-sensitive name of the extension
#     -> Information   : The extension information (can be anything)
#     -> Image         : The image link (taken from anywhere on the internet)
#     -> Download link : The link is taken by clicking on extension in github
#                        and clicking "Copy Link" on the "Download" button located
#                        right next to "Delete this file" button on the next page
#
#  2) After the list is made save by clicking "Commit new file". Open the file and click the "Raw"
#     button which is located right next to "Blame" button. When the raw mode is opened copy the link
#     from the search bar. This link is your new "STORE_LINK".
#
#  3) Now just export this as a regular .pck extension (Remember to replace wherever "VariableStore"
#     is written to your own choice name)and you are now good to go
#     (You dont have to touch the extension ever again)!!.
#
#  4) Just update the list on github as new extensions come along.
#     The extensions that are not on the list will not be available for download


var global :Node  #Needed for reference to "Global" node of Pixelorama (Used most of the time)

var extension_container :VBoxContainer
var store :Button
# This script acts as a setup for the extension
func _enter_tree() -> void:
	global = get_node_or_null("/root/Global")
	if global:
		extension_container = global.control.find_node("Extensions")
		if extension_container:
			store = load("res://src/Extensions/%s/Store/Store.tscn"  % EXTENSION_NAME).instance()
			store.get_child(0).extension_container = extension_container
			store.get_child(0).store_name = EXTENSION_NAME
			store.get_child(0).store_link = STORE_LINK
			store.text = "Open %s" % EXTENSION_NAME
			var parent = extension_container.get_node("HBoxContainer")
			parent.add_child(store)


func _exit_tree() -> void:
	store.queue_free()
