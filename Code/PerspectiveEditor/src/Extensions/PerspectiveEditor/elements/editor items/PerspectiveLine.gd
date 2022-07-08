class_name PerspectiveLine
extends Line2D

const INPUT_WIDTH := 4

var global
var start := Vector2.ZERO
var angle :float = 0
var radius :float = 19999

var track_mouse := false


func _ready() -> void:
	width = global.camera.zoom.x * 2
	Draw_Perspective_line()


func Draw_Perspective_line():
	points[0] = start
	points[1] = start + Vector2(radius * cos(deg2rad(angle)), radius * sin(deg2rad(angle)))


func Hide_Perspective_line():
	points[1] = start


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if track_mouse:
			default_color.a = 0.5
			var tmp_transform = get_canvas_transform().affine_inverse()
			var tmp_position = global.main_viewport.get_local_mouse_position()
			var mouse_point = tmp_transform.basis_xform(tmp_position) + tmp_transform.origin
			var project_size = global.current_project.size
			if Rect2(Vector2.ZERO, project_size).has_point(mouse_point):
				Draw_Perspective_line()
				var rel_vector = mouse_point - start
				var test_vector = Vector2(start.x, 0)
				if sign(test_vector.x) == 0:
					test_vector.x += 0.5

				angle = rad2deg(test_vector.angle_to(rel_vector))
				if sign(test_vector.x) == -1:
					angle += 180

				points[1] = start + Vector2(radius * cos(deg2rad(angle)), radius * sin(deg2rad(angle)))
			else:
				Hide_Perspective_line()

		update()


func _draw() -> void:
	draw_circle(start, global.camera.zoom.x * 5, default_color)
	width = global.camera.zoom.x * 2

	if points[0] == start: # Hidden line
		return

	var viewport_size: Vector2 = global.main_viewport.rect_size
	var zoom: Vector2 = global.camera.zoom

	# viewport_poly is an array of the points that make up the corners of the viewport
	var viewport_poly := [
		Vector2.ZERO, Vector2(viewport_size.x, 0), viewport_size, Vector2(0, viewport_size.y)
	]
	# Adjusting viewport_poly to take into account the camera offset, zoom, and rotation
	for p in range(viewport_poly.size()):
		viewport_poly[p] = (
			viewport_poly[p].rotated(global.camera.rotation) * zoom
			+ Vector2(
				(
					global.camera.offset.x
					- (viewport_size.rotated(global.camera.rotation).x / 2) * zoom.x
				),
				(
					global.camera.offset.y
					- (viewport_size.rotated(global.camera.rotation).y / 2) * zoom.y
				)
			)
		)

	# If there's no intersection with a viewport edge, show string in top left corner
	draw_set_transform(viewport_poly[0], global.camera.rotation, zoom * 2)
