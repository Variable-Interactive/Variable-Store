extends Panel


#var global :Node  #Needed for reference to "Global" node of Pixelorama (Used most of the time)

# This script acts as a setup for the extension
#func _enter_tree() -> void:
#	global = get_node("/root/Global")
#	if global:
#		pass


#func _exit_tree() -> void:
#	if global:
#		pass


# An example extension below (Remove it and make your own)
var moving = false
var offset = Vector2.ZERO

func _ready() -> void:
	set_global_position(OS.window_size/2.0 - rect_size/2.0)


func _on_Main_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			moving = true
			offset = get_local_mouse_position()
		else:
			moving = false

	if event is InputEventMouseMotion:
		if moving:
			set_global_position(get_global_mouse_position() - offset)
