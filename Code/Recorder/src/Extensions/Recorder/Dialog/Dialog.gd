extends WindowDialog


enum Mode {CANVAS, PIXELORAMA}

onready var project_list = $VBoxContainer/TargetProject/TargetProjectOption
onready var start_button = $VBoxContainer/HBoxContainer/Start
onready var path_field = $VBoxContainer/Destination/Path

var extension_api :Node  # Needed for reference to "Global" node of Pixelorama (Used most of the time)
var project

var cache :Array = []

var mode = 0
var save_dir = ""
var frame_captured = 0

signal frame_saved

func _ready() -> void:
	show()
	refresh_projects_list()
	project = extension_api.get_global().current_project
# warning-ignore:return_value_discarded
	connect("frame_saved", self, "_on_frame_saved")


func initialize_recording():
	connect_undo()
	cache.clear()
	frame_captured = 0
	start_button.text = "Stop Recording"
	for child in $VBoxContainer.get_children():
		if !child.is_in_group("visible during recording"):
			child.visible = false
	rect_min_size = Vector2(235, 101)
	rect_size = rect_min_size
	capture_frame() # capture first frame
	$Timer.start()


func capture_frame() -> void:
	var image := Image.new()
	if mode == Mode.PIXELORAMA:
		image = get_tree().root.get_viewport().get_texture().get_data()
		image.flip_y()
	else:
		image = get_frame_image()
	cache.append(image)


func _on_Timer_timeout() -> void:
	if cache.size() > 0:
		save_frame(cache[0])
		cache.remove(0)


func save_frame(img :Image) -> void:
	var save_file = str(project.name, "_", frame_captured, ".png")
# warning-ignore:return_value_discarded
	img.save_png(save_dir.plus_file(save_file))
	emit_signal("frame_saved")


func finalize_recording():
	$Timer.stop()
	for img in cache:
		save_frame(img)
	cache.clear()
	disconnect_undo()
	start_button.text = "Start Recording"
	rect_min_size = Vector2(400, 270)
	for child in $VBoxContainer.get_children():
		child.visible = true


func _on_frame_saved():
	frame_captured += 1
	$VBoxContainer/HBoxContainer/Info/Captured.text = str(frame_captured)


func disconnect_undo() -> void:
	project.undo_redo.disconnect("version_changed", self, "capture_frame")


func connect_undo() -> void:
	project.undo_redo.connect("version_changed", self, "capture_frame")


func _on_Mode_value_changed(value: float) -> void:
	mode = value


func _on_TargetProjectOption_item_selected(index: int) -> void:
	finalize_recording()
	project = extension_api.get_global().projects[index]


func _on_TargetProjectOption_pressed() -> void:
	refresh_projects_list()


func refresh_projects_list() -> void:
	project_list.clear()
	for proj in extension_api.get_global().projects:
		project_list.add_item(proj.name)


func _on_Start_toggled(button_pressed: bool) -> void:
	if button_pressed:
		initialize_recording()
	else:
		finalize_recording()


func _on_Choose_pressed() -> void:
	$Path.popup_centered()
	$Path.current_dir = ProjectSettings.globalize_path("res://")


func _on_Path_dir_selected(dir: String) -> void:
	save_dir = dir
	path_field.text = save_dir
	start_button.disabled = false


func _on_Recorder_visibility_changed() -> void:  # Popup the dialog
	if visible:
		set_global_position(OS.window_size/2.0 - rect_size/2.0)


func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		var mouse_pos = get_local_mouse_position()

		# Avoid canvas interaction if hovering above dialog
		if extension_api.get_global():
			if Rect2(Vector2.ZERO, rect_size).has_point(mouse_pos):
				extension_api.get_global().can_draw = false
			else:
				if extension_api.get_global().has_focus:
					extension_api.get_global().can_draw = true


# Blends selected cels of the given frame into passed image starting from the origin position
func get_frame_image() -> Image:
	var current_frame := Image.new()
	var proj = project
	current_frame.create(
		proj.size.x, proj.size.y, false, Image.FORMAT_RGBA8
	)
	var frame = proj.frames[proj.current_frame]
	var origin: Vector2 = Vector2(0, 0)
	var layer_i := 0
	for cel in frame.cels:
		if proj.layers[layer_i].visible:
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
			current_frame.blend_rect(cel_image, Rect2(Vector2.ZERO, proj.size), origin)
			cel_image.unlock()
		layer_i += 1
	current_frame.unlock()
	return current_frame


