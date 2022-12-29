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
		prepare_progress()


func prepare_progress():
	$ProgressPanel.visible = true
	$ProgressPanel/VBoxContainer/ProgressBar.value = 0
	$ProgressPanel/UpdateTimer.start()


func _on_UpdateTimer_timeout():
	update_progress()


func update_progress():
	var down = http.get_downloaded_bytes()
	var total = http.get_body_size()
	$ProgressPanel/VBoxContainer/ProgressBar.value = (float(down) / float(total)) * 100.0


func close_progress():
	$ProgressPanel.visible = false
	$ProgressPanel/UpdateTimer.stop()


func _on_HTTPRequest_request_completed(result: int, _response_code: int, _headers: PoolStringArray, _body: PoolByteArray) -> void:
	if result == HTTPRequest.RESULT_SUCCESS:
		# Hide the progress bar because it's no longer required
		close_progress()

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
		error_getting_info()


func add_entry(info: Array) -> void:
	var entry = load("res://src/Extensions/%s/Store/Entry/Entry.tscn" % store_name).instance()
	entry.extension_container = extension_container
	content.add_child(entry)
	entry.set_info(info, extension_path)


func error_getting_info():
	$Error.popup_centered()
	close_progress()


func _on_CopyCommand_pressed():
	OS.clipboard = "sudo flatpak override com.orama_interactive.Pixelorama --share=network"


func _on_ManualDownload_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open("https://variable-interactive.itch.io/pixelorama-extensions")


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
