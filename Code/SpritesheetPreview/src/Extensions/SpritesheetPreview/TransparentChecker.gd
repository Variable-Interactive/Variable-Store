extends ColorRect

var global :Node  #Needed for reference to "global" node of Pixelorama (Used most of the time)


func _ready() -> void:
	global = get_node("/root/Global")
	if global:
		update_rect()


func update_rect() -> void:
	material.set_shader_param("color1", global.checker_color_1)
	material.set_shader_param("color2", global.checker_color_2)
	material.set_shader_param("follow_movement", global.checker_follow_movement)
