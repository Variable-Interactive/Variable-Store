class_name VanishingPoint
extends Node

var perspective_lines = []

var global
var main
var start :Vector2
var angles := []
var radiai = []
var color :Color


func initiate() -> void:
	for index in angles.size() + 1:
		var line = preload("res://src/Extensions/PerspectiveEditor/elements/editor items/PerspectiveLine.tscn").instance()
		line.start = start
		line.default_color = color
		line.global = global
		if index != 0: # We need the first line for Following the mouse
			line.angle = angles[index - 1]
			line.radius = radiai[index - 1]
		else:
			line.track_mouse = true
		perspective_lines.append(line)
		global.canvas.add_child(line)

	if main:
		main.add_child(self)


func add_line():
	var line = preload("res://src/Extensions/PerspectiveEditor/elements/editor items/PerspectiveLine.tscn").instance()
	line.start = start
	line.angle = 0
	line.default_color = color
	line.global = global
	perspective_lines.append(line)
	global.canvas.add_child(line)


func change_radius_and_angle(line_ind):
	var end = start + Vector2(radiai[line_ind] * cos(deg2rad(angles[line_ind])), radiai[line_ind] * sin(deg2rad(angles[line_ind])))
	perspective_lines[line_ind + 1].points[1] = end


func remove_line(idx):
	var target = perspective_lines[idx + 1]
	perspective_lines.remove(idx + 1)
	angles.remove(idx)
	target.queue_free()


func _exit_tree() -> void:
	for line in perspective_lines:
		line.queue_free()
