extends WindowDialog

var global :Node  #Needed for reference to "Global" node of Pixelorama (Used most of the time)
onready var http = $HTTPRequest
var extension_container :VBoxContainer
var extension_path: String = ""

#### Usage:
### Change the "store_version", "store_link" and "download_file" variables to your choice
### Don't touch anything else
var download_file: String = "variable_info.txt" #File can be of any name you want
var store_link: String = "https://raw.githubusercontent.com/Variable-ind/Pixelorama-Extensions/master/store_info.txt"
var store_version: float = 0.1

var new_version_available := false
### Principle/Setup:
#  1) Make a file in the repository and store all the extensions inside it in
#     the form of
#     ["Name", "Information", "Image", "Download Link"]
#     -> Name          : The EXACT case-sensitive name of the extension
#     -> Information   : The extension information (can be anything)
#     -> Image         : The image link (taken from anywhere on the internet)
#     -> Download link : The link is taken by clicking on extension in github
#                        and clicking "Copy Link" on the "Download" button located
#                        right next to "Delete this file" button on the next page
#
#  2) After the list is made save by clicking "Commit new file". Open the file and click the "Raw"
#     button which is located right next to "Blame" button. When the raw mode is opened copy the link
#     from the search bar. This link is your new "store_link" variable.
#
#  3) Now just export this as a regular .pck extension (Remember to replace wherever "VariableStore"
#     is written to your own choice name)and you are now good to go
#     (You dont have to touch the extension ever again)!!.
#
#  4) Just update the list on github as new extensions come along.
#     The extensions that are not on the list will not be available for download


onready var content = $Panel/ScrollContainer/Content


func _on_StoreButton_pressed() -> void:
	popup_centered()


func _on_Store_about_to_show() -> void:
	# Display Version
	if !window_title.ends_with(str(" (", store_version, ")")):
		window_title += str(" (", store_version, ")")

	#Clear old entries
	for entry in content.get_children():
		entry.queue_free()

	# Some Essential settings
	global = get_node_or_null("/root/Global")
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

		var dummy_number = 1
		while not file.eof_reached():
			var info = str2var(file.get_line())
			if typeof(info) == TYPE_REAL:
				# check version
				version = info
				if version > store_version:
					new_version_available = true
			elif typeof(info) == TYPE_ARRAY:
				if dummy_number >= 3:
					if new_version_available:
						if dummy_number == 3:
							var label := Label.new()
							label.text = str("Version ", version, " is Available")
							content.add_child(label)
							add_entry(info)  # Announce update
					else:
						if dummy_number > 3:  # The first 3 lines of file are Store-related and are excluded
							add_entry(info)
			dummy_number += 1
		file.close()
		var dir := Directory.new()
		dir.remove(str(extension_path,download_file))
	else:
		printerr("Unable to Get info from remote repository...")


func add_entry(info: Array) -> void:
	var entry = preload("res://src/Extensions/VariableStore/Store/Entry/Entry.tscn").instance()
	entry.extension_container = extension_container
	content.add_child(entry)
	entry.set_info(info, extension_path)
