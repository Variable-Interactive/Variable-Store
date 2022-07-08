extends Line2D

const INPUT_WIDTH := 4

enum Types {VERTICAL, HORIZONTAL}

export var type := 0
var global

var track_mouse := true



func _ready() -> void:
	default_color.a = 0.5
	width = global.camera.zoom.x * 2
	Draw_Perspective_line()


func Draw_Perspective_line():
	if type == Types.HORIZONTAL:
		points[0] = Vector2(-19999, 0)
		points[1] = Vector2(19999, 0)
	else:
		points[0] = Vector2(0, 19999)
		points[1] = Vector2(0, -19999)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_point = get_local_mouse_position()
		var project_size = global.current_project.size
		if Rect2(Vector2.ZERO, project_size).has_point(mouse_point):
				visible = true
		else:
			visible = false
			return
		if type == Types.HORIZONTAL:
			points[0].y = mouse_point.y
			points[1].y = mouse_point.y
		else:
			points[0].x = mouse_point.x
			points[1].x = mouse_point.x
	update()


func _draw() -> void:
	width = global.camera.zoom.x * 2
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
