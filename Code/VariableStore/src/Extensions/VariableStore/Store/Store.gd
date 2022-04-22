extends WindowDialog

### Usage:
### Change the "EXTENSION_NAME" and "STORE_LINK" from the (Main.gd)
### Don't touch anything else

var extension_container :VBoxContainer
var extension_path: String = ""

var store_link :String
var store_name :String
var download_file :String
var store_version :float
var new_version_available := false


onready var http = $HTTPRequest
onready var content = $Panel/ScrollContainer/Content


func _on_StoreButton_pressed() -> void:
	popup_centered()


func _on_Store_about_to_show() -> void:
	# Basic setup
	download_file = str(store_name,".txt")
	store_version = get_store_version_info()
	window_title = str(store_name, " (", store_version, ")")

	#Clear old entries
	for entry in content.get_children():
		entry.queue_free()

	# Some Essential settings
	var global: Node = get_node_or_null("/root/Global")
	if global:
		extension_container = global.control.find_node("Extensions")
		if extension_container:
			extension_path = ProjectSettings.globalize_path(extension_container.EXTENSIONS_PATH)
			if !extension_path.ends_with("/"):
				extension_path += "/"
		else:
			return

		http.download_file = str(extension_path,download_file)
		var _error = http.request(store_link)


func _on_HTTPRequest_request_completed(result: int, _response_code: int, _headers: PoolStringArray, _body: PoolByteArray) -> void:
	if result == HTTPRequest.RESULT_SUCCESS:
		var file = File.new()
		var _error = file.open(str(extension_path,download_file), File.READ)
		var version :float

		while not file.eof_reached():
			var info = str2var(file.get_line())
			if typeof(info) == TYPE_REAL:
				# check version
				version = info
				if version > store_version and !new_version_available:
					new_version_available = true
			elif typeof(info) == TYPE_ARRAY:
				if new_version_available:
					var label := Label.new()
					label.text = str("Version ", version, " is Available")
					content.add_child(label)
					add_entry(info)  # Announce update
					break
				else:
					if info[0] != store_name:
						add_entry(info)
		file.close()
		var dir := Directory.new()
		_error = dir.remove(str(extension_path, download_file))
	else:
		printerr("Unable to Get info from remote repository...")


func add_entry(info: Array) -> void:
	var entry = load("res://src/Extensions/%s/Store/Entry/Entry.tscn" % store_name).instance()
	entry.extension_container = extension_container
	content.add_child(entry)
	entry.set_info(info, extension_path)


func error_getting_info():
	$Error/Text.text = str($Error/Text.text % store_name)
	$Error.popup_centered()


func get_store_version_info() -> float:
	var store_config_file_path: String = "res://src/Extensions/%s/extension.json" % store_name
	var store_config_file := File.new()
	var err := store_config_file.open(store_config_file_path, File.READ)
	if err != OK:
		printerr("Error loading config file: ", err)
		store_config_file.close()
		return float(0)

	var info_json = parse_json(store_config_file.get_as_text())
	store_config_file.close()

	if !info_json:
		printerr("No JSON data found.")
		return float(0)

	if info_json.has("version"):
		var version = str2var(info_json["version"])
		if typeof(version) == TYPE_REAL:
			return version
		else:
			return version
	else:
		return float(0)
