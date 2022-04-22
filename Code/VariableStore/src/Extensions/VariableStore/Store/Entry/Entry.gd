extends Panel

### Usage:
### Change the "EXTENSION_NAME" and "STORE_LINK" from the (Main.gd)
### Don't touch anything else

onready var ext_name = $Panel/HBoxContainer/VBoxContainer/Name
onready var ext_discription = $Panel/HBoxContainer/VBoxContainer/Description
onready var ext_picture = $Panel/HBoxContainer/Picture

var extension_container :VBoxContainer
var thumbnail := ""
var download_link := ""
var download_path := ""

onready var download_request = $DownloadRequest

func set_info(info: Array, extension_path: String) -> void:
	ext_name.text = info[0]
	ext_discription.text = info[1]
	thumbnail = info[2]
	download_link = info[3]
	var dir := Directory.new()
	var _error = dir.make_dir_recursive(str(extension_path,"Download/"))
	download_path = str(extension_path,"Download/",info[0],".pck")

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


func _on_Button_pressed() -> void:
	# Download File
	$Panel/HBoxContainer/VBoxContainer/Button.disabled = true
	download_request.download_file = download_path
	download_request.request(download_link)


func _on_DownloadRequest_request_completed(result: int, _response_code, _headers, _body) -> void:
	if result == HTTPRequest.RESULT_SUCCESS:
		# Add extension
		extension_container.install_extension(download_path)
		announce_done(true)
	else:
		$Error.dialog_text = str("Unable to Download extension...\nHttp Code (",result,")").c_unescape()
		$Error.popup_centered()
		announce_done(false)
	var dir := Directory.new()
	var _error = dir.remove(download_path)


func announce_done(success: bool):
	$Panel/HBoxContainer/VBoxContainer/Button.disabled = false
	if success:
		$Panel/HBoxContainer/VBoxContainer/Done.visible = true
	$DoneDelay.start()


func _on_DoneDelay_timeout() -> void:
	$Panel/HBoxContainer/VBoxContainer/Done.visible = false


