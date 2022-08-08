extends Node

var extension_api :Node  # Needed for reference to "ExtensionsApi" node of Pixelorama (Used most of the time)

var neon_silver = preload("res://src/Extensions/ThemePack/NeonSilver/theme.tres")
var neon_blue = preload("res://src/Extensions/ThemePack/NeonBlue/theme.tres")
var neon_pink = preload("res://src/Extensions/ThemePack/NeonPink/theme.tres")
var pixel_sprite = preload("res://src/Extensions/ThemePack/PixelSprite/theme.tres")
var current_theme

# This script acts as a setup for the extension
func _enter_tree() -> void:
	extension_api = get_node_or_null("/root/ExtensionsApi")
	if extension_api:
		current_theme = extension_api.get_theme()
		extension_api.add_theme(neon_silver)
		extension_api.add_theme(neon_blue)
		extension_api.add_theme(neon_pink)
		extension_api.add_theme(pixel_sprite)


func _exit_tree() -> void:
	if extension_api:
		extension_api.remove_theme(neon_silver)
		extension_api.remove_theme(neon_blue)
		extension_api.remove_theme(neon_pink)
		extension_api.remove_theme(pixel_sprite)
