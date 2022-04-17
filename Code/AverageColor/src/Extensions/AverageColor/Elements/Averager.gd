extends VBoxContainer

onready var average_button = $AverageColor
var left_color :Color
var right_color :Color
var left_button :ColorPickerButton
var right_button :ColorPickerButton
var average :Color

var tools :Node  #Needed for reference to "Tools" node of Pixelorama


func _ready() -> void:
	tools = get_node("/root/Tools")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if left_color != left_button.color:
			left_color = left_button.color
		if right_color != right_button.color:
			right_color = right_button.color
		_average()


func _average():
	var average_r = (left_color.r + right_color.r) / 2.0
	var average_g = (left_color.g + right_color.g) / 2.0
	var average_b = (left_color.b + right_color.b) / 2.0
	var average_a = (left_color.a + right_color.a) / 2.0

	average = Color(average_r, average_g, average_b, average_a)
	$AverageColor/ColorRect.color = average


func _on_AverageColor_gui_input(event: InputEvent) -> void:
	if tools:
		if event is InputEventMouseButton:
			if event.pressed:
				if event.button_index == BUTTON_LEFT:
					tools.assign_color(average, BUTTON_LEFT)
				elif event.button_index == BUTTON_RIGHT:
					tools.assign_color(average, BUTTON_RIGHT)
