extends WindowDialog

enum Orientation { ROWS = 0, COLUMNS = 1 }

var global :Node  #Needed for reference to "global" node of Pixelorama (Used most of the time)
onready var previews = $VBoxContainer/Preview/PreviewPanel/ScrollContainer/Previews
onready var spritesheet_lines_count_label = $VBoxContainer/Preview/Orientation/HBoxContainer2/LinesCountLabel
onready var spritesheet_lines_count = $VBoxContainer/Preview/Orientation/HBoxContainer2/LinesCount
onready var spritesheet_orientation = $VBoxContainer/Preview/Orientation/HBoxContainer/Orientation

var processed_images = []  # Image[]
var number_of_frames := 1
var orientation: int = Orientation.ROWS

var lines_count := 1  # How many rows/columns before new line is added


# This script acts as a setup for the extension
func _enter_tree() -> void:
	global = get_node("/root/Global")


func _ready() -> void:
	$RefreshTimer.start()
	set_global_position(OS.window_size/2.0 - rect_size/2.0)
	get_close_button().visible = false
	show()


func _input(event: InputEvent) -> void:
	if (event is InputEventKey
	or event is InputEventMouseButton):
		if !event.pressed:
			$RefreshTimer.start()

	if event is InputEventMouse:
		var mouse_pos = get_local_mouse_position()
		# Avoid canvas interaction if hovering above dialog
		if global:
			if Rect2(Vector2.ZERO, rect_size).has_point(mouse_pos):
				global.can_draw = false
			else:
				if global.has_focus:
					global.can_draw = true


func _on_RefreshTimer_timeout() -> void:
	set_preview()


func set_preview() -> void:
	if global:
		remove_previews()
		process_spritesheet()

		spritesheet_orientation.selected = orientation
		spritesheet_lines_count.max_value = number_of_frames
		spritesheet_lines_count.value = lines_count
		previews.columns = ceil(sqrt(processed_images.size()))

		for i in range(processed_images.size()):
			add_image_preview(processed_images[i], i + 1)


func remove_previews() -> void:
	for child in previews.get_children():
		child.free()


func add_image_preview(image: Image, _canvas_number: int = -1) -> void:
	if image.get_width() > 0 and image.get_height() > 0:
		var container = create_preview_container()
		var preview = create_preview_rect()
		preview.texture = ImageTexture.new()
		preview.texture.create_from_image(image, 0)
		container.add_child(preview)
		previews.add_child(container)


#### Helper Methods
func process_spritesheet() -> void:
	processed_images.clear()
	# Range of frames determined by tags
	var frames := []
	frames = global.current_project.frames

	# Then store the size of frames for other functions
	number_of_frames = frames.size()

	# If rows mode selected calculate columns count and vice versa
	var spritesheet_columns = (
		lines_count
		if orientation == Orientation.ROWS
		else frames_divided_by_spritesheet_lines()
	)
	var spritesheet_rows = (
		lines_count
		if orientation == Orientation.COLUMNS
		else frames_divided_by_spritesheet_lines()
	)

	var width = global.current_project.size.x * spritesheet_columns
	var height = global.current_project.size.y * spritesheet_rows

	if width == 0 or height == 0:  # Sanity check
		return

	var whole_image := Image.new()
	whole_image.create(width, height, false, Image.FORMAT_RGBA8)
	var origin := Vector2.ZERO
	var hh := 0
	var vv := 0

	for frame in frames:
		if orientation == Orientation.ROWS:
			if vv < spritesheet_columns:
				origin.x = global.current_project.size.x * vv
				vv += 1
			else:
				hh += 1
				origin.x = 0
				vv = 1
				origin.y = global.current_project.size.y * hh
		else:
			if hh < spritesheet_rows:
				origin.y = global.current_project.size.y * hh
				hh += 1
			else:
				vv += 1
				origin.y = 0
				hh = 1
				origin.x = global.current_project.size.x * vv
		blend_layers(whole_image, frame, origin)

	processed_images.append(whole_image)


func create_preview_container() -> VBoxContainer:
	var container = VBoxContainer.new()
	container.size_flags_horizontal = SIZE_EXPAND_FILL
	container.size_flags_vertical = SIZE_EXPAND_FILL
	container.rect_min_size = Vector2(0, 128)
	return container


func create_preview_rect() -> TextureRect:
	var preview = TextureRect.new()
	preview.expand = true
	preview.size_flags_horizontal = SIZE_EXPAND_FILL
	preview.size_flags_vertical = SIZE_EXPAND_FILL
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	return preview


# Blends canvas layers into passed image starting from the origin position
func blend_layers(image: Image, frame, origin: Vector2 = Vector2(0, 0)) -> void:
	image.lock()
	var layer_i := 0
	for cel in frame.cels:
		if global.current_project.layers[layer_i].visible:
			var cel_image := Image.new()
			cel_image.copy_from(cel.image)
			cel_image.lock()
			if cel.opacity < 1:  # If we have cel transparency
				for xx in cel_image.get_size().x:
					for yy in cel_image.get_size().y:
						var pixel_color := cel_image.get_pixel(xx, yy)
						var alpha: float = pixel_color.a * cel.opacity
						cel_image.set_pixel(
							xx, yy, Color(pixel_color.r, pixel_color.g, pixel_color.b, alpha)
						)
			image.blend_rect(cel_image, Rect2(Vector2.ZERO, global.current_project.size), origin)
			cel_image.unlock()
		layer_i += 1
	image.unlock()


func frames_divided_by_spritesheet_lines() -> int:
	return int(ceil(number_of_frames / float(lines_count)))


#### SpriteSheet Option Signals
func _on_Orientation_item_selected(id: int) -> void:
	orientation = id
	if orientation == Orientation.ROWS:
		spritesheet_lines_count_label.text = "Columns:"
	else:
		spritesheet_lines_count_label.text = "Rows:"
	spritesheet_lines_count.value = frames_divided_by_spritesheet_lines()
	set_preview()


func _on_LinesCount_value_changed(value: int) -> void:
	lines_count = value
	set_preview()
