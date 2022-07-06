extends ImageEffect

var extension_api :Node  # Needed for reference to "ExtensionApi" node of Pixelorama (Used most of the time)
var global :Node  # Needed for reference to "Global" node of Pixelorama (Used most of the time)
var opensave :Node  # Needed for reference to "OpenSave" node of Pixelorama (Used most of the time)
var shader: Shader = preload("res://src/Extensions/UVHelperPack/elements/ApplyMapDialog/lookup_shader.gdshader")
var map := ImageTexture.new()

var main :Node  # Used for communication between different extension elements
var path :String

func _ready() -> void:
	extension_api = get_node_or_null("/root/ExtensionsApi")
	global = get_node_or_null("/root/Global")
	opensave = get_node_or_null("/root/OpenSave")
	$MapLoader.connect("hide", self, "on_loader_hide")
	var sm := ShaderMaterial.new()
	sm.shader = shader
	preview.set_material(sm)
	global.tabs.connect("tab_changed", self, "tab_changed")


func set_nodes() -> void:
	preview = $VBoxContainer/AspectRatioContainer/Preview
	selection_checkbox = $VBoxContainer/OptionsContainer/SelectionCheckBox
	affect_option_button = $VBoxContainer/OptionsContainer/AffectOptionButton


func commit_action(cel: Image, project: Project = global.current_project) -> void:
	var size = Vector2.ONE # the default value

	if !map.get_data(): # if there's no image loaded
		var img := Image.new()
		img.create(1, 1, false, Image.FORMAT_ETC2_RGBA8)
		map.create_from_image(img, 0)

	size = map.get_data().get_size()

	var params := {
		"map_texture": map,
		"map_size": size
	}

	main.preview_dialog.map_texture = map
	main.preview_dialog.update_preview()

	if !confirmed:
		for param in params:
			preview.material.set_shader_param(param, params[param])
	else:
		var gen := ShaderImageEffect.new()
		gen.generate_image(cel, shader, params, project.size)
		yield(gen, "done")


func _on_MapLoader_file_selected(path: String) -> void:
	open_image(path)
	update_preview()


func on_loader_hide():
	update_preview()


func _on_Load_pressed() -> void:
	$MapLoader.popup(Rect2(self.rect_position, $MapLoader.rect_size))
	if opensave:
		var save_path = opensave.current_save_paths[global.current_project_index]
		$MapLoader.current_path = save_path


func tab_changed(id :int):
	if path:
		open_image(path)
		update_preview()


func open_image(file: String):
	file = file.replace("\\", "/")

	var file_ext: String = file.get_extension().to_lower()
	var image := Image.new()
	var err := image.load(file)
	if err != OK:  # An error occured
		var global = get_node_or_null("/root/Global")
		if global:
			var file_name: String = file.get_file()
			Global.error_dialog.set_text(
				tr("Can't load file '%s'.\nError code: %s") % [file_name, str(err)]
			)
			Global.error_dialog.popup_centered()
			Global.dialog_open(true)

	map.create_from_image(image, 0)
	main.preview_dialog.map_title.text = str("Map name ", file.get_file())
	path = file
