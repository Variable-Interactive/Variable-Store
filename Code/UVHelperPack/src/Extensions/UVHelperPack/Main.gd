extends Node

var extension_api :Node  # Needed for reference to "ExtensionApi" node of Pixelorama (Used most of the time)
var global :Node  # Needed for reference to "Global" node of Pixelorama (Used most of the time)
var preview_dialog # Its a kind of "Custom Dialog" i designed myself
var apply_dialog # Applies a Map to UV image
var menu_idx :int

# This script acts as a setup for the extension
func _enter_tree() -> void:
	extension_api = get_node_or_null("/root/ExtensionsApi")

	if extension_api:
		global = extension_api.get_global()

		# Adding Tools
		extension_api.add_tool(
			"UVLineTool",
			"UV Line Tool",
			"",
			preload("res://src/Extensions/UVHelperPack/elements/line/LineTool.tscn"),
			"""Hold %s to snap the angle of the line
	Hold %s to center the shape on the click origin
	Hold %s to displace the shape's origin""",
			["shape_perfect", "shape_center", "shape_displace"]
		)

		extension_api.add_tool(
			"UVColorPicker",
			"UV Color Picker",
			"",
			preload("res://src/Extensions/UVHelperPack/elements/colorpicker/ColorPicker.tscn"),
			"Select a color from a pixel of the sprite"
		)

		var parent = global.control.get_node("Dialogs")
		# Adding Apply map to uv Dialog
		menu_idx = extension_api.add_menu_item(3, "Apply Map texture", {})
		global.top_menu_container.image_menu_button.get_popup().connect("index_pressed", self, "image_menu_idx_pressed")
		apply_dialog = preload("res://src/Extensions/UVHelperPack/elements/ApplyMapDialog/ApplyMap.tscn").instance()
		parent.call_deferred("add_child", apply_dialog)
		apply_dialog.main = self

		# Preview
		preview_dialog = preload("res://src/Extensions/UVHelperPack/elements/preview/Preview.tscn").instance()
		parent.call_deferred("add_child", preview_dialog)
		preview_dialog.show()
		preview_dialog.main = self


func image_menu_idx_pressed(idx :int):
	if idx == menu_idx: # just a random id :)
		apply_dialog.popup(Rect2(preview_dialog.rect_position, apply_dialog.rect_size))
		extension_api.dialog_open(true)


func _exit_tree() -> void:
	if extension_api:
		if global:
			preview_dialog.queue_free()
			apply_dialog.queue_free()
			extension_api.remove_tool("UVLineTool")
			extension_api.remove_tool("UVColorPicker")
			extension_api.remove_menu_item(3, menu_idx)
