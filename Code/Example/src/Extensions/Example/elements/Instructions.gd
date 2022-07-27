extends WindowDialog


####################################################
###                                              ###
########       Enter Your code Here         ########

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_global = get_node_or_null("/root/Global")
	set_global_position(OS.window_size/2.0 - rect_size/2.0)
	show()


func _on_Button_pressed() -> void:
	OS.clipboard = $VBoxContainer/Content/VBoxContainer/HBoxContainer/Code.text


func _on_Create_pressed() -> void:
	$NewExtension.popup_centered()

###                                             ####
####################################################



#### You don't have to touch anything below
var _global :Node  # Needed for reference to "Global" node of Pixelorama (Used most of the time)


func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		var mouse_pos = get_local_mouse_position()

		# Avoid canvas interaction if hovering above dialog
		if _global:
			if Rect2(Vector2.ZERO, rect_size).has_point(mouse_pos):
				_global.can_draw = false
			else:
				if _global.has_focus:
					_global.can_draw = true


