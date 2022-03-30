extends Node

var global :Node  #Needed for reference to "Global" node of Pixelorama


# This script acts as a setup for the extension
func _enter_tree() -> void:
	global = get_node("/root/Global")
	if global:
		#set the new font
		global.control.theme.default_font.font_data = preload("res://src/Extensions/zpix-font-ext/zpix.ttf")


func _exit_tree() -> void:
	if global:
		#set the default font back again
		global.control.theme.default_font.font_data = load("res://assets/fonts/Roboto-Regular.ttf")
