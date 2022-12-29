extends Panel

### Usage:
### Change the "EXTENSION_NAME" and "STORE_LINK" from the (Main.gd)
### Don't touch anything else

onready var ext_name = $Panel/HBoxContainer/VBoxContainer/Name
onready var ext_discription = $Panel/HBoxContainer/VBoxContainer/Description
onready var ext_picture = $Panel/HBoxContainer/Picture
onready var down_button = $Panel/HBoxContainer/VBoxContainer/Download

var extension_container :VBoxContainer
var thumbnail := ""
var download_link := ""
var download_path := ""
var is_update = false  # An update instead of download

onready var download_request = $DownloadRequest

func set_info(info: Array, extension_path: String) -> void:
	ext_name.text = str(info[0], "-v", info[1])  # Name with version
	ext_discription.text = info[2]  # Description
	thumbnail = info[-2]  # Image link
	download_link = info[-1]  # Download link

	var dir := Directory.new()
	var _error = dir.make_dir_recursive(str(extension_path,"Download/"))
	download_path = str(extension_path,"Download/",info[0],".pck")
	set_if_updatable(info[0], info[1])

	$RequestDelay.wait_time = randf() * 2 #to prevent sending bulk requests
	$RequestDelay.start()


func _on_RequestDelay_timeout() -> void:
	$RequestDelay.queue_free()
	var _error = $ImageRequest.request(thumbnail) #image


func _on_ImageRequest_request_completed(_result, _response_code, _headers, body: PoolByteArray) -> void:
	# Update the recieved image
	$ImageRequest.queue_free()
	var image = Image.new()
	var _error = image.load_jpg_from_buffer(body)
	if _error != OK:
		var _err1 = image.load_png_from_buffer(body)
		if _err1 != OK:
			var _err2 = image.load_webp_from_buffer(body)
			if _err2 != OK:
				var _err3 = image.load_tga_from_buffer(body)
				if _err3 != OK:
					var _err4 = image.load_bmp_from_buffer(body)
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	ext_picture.texture = texture


func set_if_updatable(name: String, new_version: float):
	for extension in extension_container.extensions.keys():
		if extension_container.extensions[extension].file_name == name:
			var old_version = str2var(extension_container.extensions[extension].version)
			if typeof(old_version) == TYPE_REAL:
				if new_version > old_version:
					down_button.text = "Update"
					is_update = true
				elif new_version == old_version:
					down_button.text = "Re-Download"


func _on_Download_pressed() -> void:
	# Download File
	down_button.disabled = true
	download_request.download_file = download_path
	download_request.request(download_link)
	prepare_progress()


func prepare_progress():
	$Panel/HBoxContainer/VBoxContainer/ProgressBar.visible = true
	$Panel/HBoxContainer/VBoxContainer/ProgressBar.value = 0
	$Panel/HBoxContainer/VBoxContainer/ProgressBar/ProgressTimer.start()


func _on_ProgressTimer_timeout():
	update_progress()


func update_progress():
	var down = download_request.get_downloaded_bytes()
	var total = download_request.get_body_size()
	$Panel/HBoxContainer/VBoxContainer/ProgressBar.value = (float(down) / float(total)) * 100.0


func close_progress():
	$Panel/HBoxContainer/VBoxContainer/ProgressBar.visible = false
	$Panel/HBoxContainer/VBoxContainer/ProgressBar/ProgressTimer.stop()


func _on_DownloadRequest_request_completed(result: int, _response_code, _headers, _body) -> void:
	if result == HTTPRequest.RESULT_SUCCESS:
		# Add extension
		extension_container.install_extension(download_path)
		if is_update:
			is_update = false
		announce_done(true)
	else:
		$Alert/Text.text = str("Unable to Download extension...\nHttp Code (",result,")").c_unescape()
		$Alert.popup_centered()
		announce_done(false)
	var dir := Directory.new()
	var _error = dir.remove(download_path)


func announce_done(success: bool):
	close_progress()
	down_button.disabled = false
	down_button.text = "Re-Download"
	if success:
		$Panel/HBoxContainer/VBoxContainer/Done.visible = true
	$DoneDelay.start()


func _on_DoneDelay_timeout() -> void:
	$Panel/HBoxContainer/VBoxContainer/Done.visible = false
