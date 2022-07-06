extends BaseTool

var _prev_mode := 0
var _color_slot := 0
enum Mode {PICK_COLOR, PICK_COORDINATE}
var pick_mode := 0  # 0 is "pick coor", 1 is "pick coordinate"


func _input(event: InputEvent) -> void:
	var options: OptionButton = $ColorPicker/Options
	var color = Tools.get_assigned_color(_color_slot + 1)
	$ColorPicker/R/Tweak.disconnect("value_changed", self, "_on_Tweak_value_changed")
	$ColorPicker/G/Tweak.disconnect("value_changed", self, "_on_Tweak_value_changed")
	$ColorPicker/B/Tweak.disconnect("value_changed", self, "_on_Tweak_value_changed")
	$ColorPicker/A/Tweak.disconnect("value_changed", self, "_on_Tweak_value_changed")
	$ColorPicker/R/Tweak.value = color.r8
	$ColorPicker/G/Tweak.value = color.g8
	$ColorPicker/B/Tweak.value = color.b8
	$ColorPicker/A/Tweak.value = color.a8
	$ColorPicker/R/Tweak.connect("value_changed", self, "_on_Tweak_value_changed", ["R"])
	$ColorPicker/G/Tweak.connect("value_changed", self, "_on_Tweak_value_changed", ["G"])
	$ColorPicker/B/Tweak.connect("value_changed", self, "_on_Tweak_value_changed", ["B"])
	$ColorPicker/A/Tweak.connect("value_changed", self, "_on_Tweak_value_changed", ["A"])

	if event.is_action_pressed("change_tool_mode"):
		_prev_mode = options.selected
	if event.is_action("change_tool_mode"):
		options.selected = _prev_mode ^ 1
		_color_slot = options.selected
	if event.is_action_released("change_tool_mode"):
		options.selected = _prev_mode
		_color_slot = options.selected


func _on_Options_item_selected(id: int) -> void:
	_color_slot = id
	update_config()
	save_config()


func get_config() -> Dictionary:
	return {
		"color_slot": _color_slot,
	}


func set_config(config: Dictionary) -> void:
	_color_slot = config.get("color_slot", _color_slot)


func update_config() -> void:
	$ColorPicker/Options.selected = _color_slot


func draw_start(position: Vector2) -> void:
	.draw_start(position)
	_pick_color(position)


func draw_move(position: Vector2) -> void:
	.draw_move(position)
	_pick_color(position)


func draw_end(position: Vector2) -> void:
	.draw_end(position)


func _pick_color(position: Vector2) -> void:
	var project: Project = Global.current_project
	position = project.tiles.get_canon_position(position)

	if position.x < 0 or position.y < 0:
		return

	var color := Color.black
	match pick_mode:
		Mode.PICK_COLOR:
			var image := Image.new()
			image.copy_from(_get_draw_image())
			if position.x > image.get_width() - 1 or position.y > image.get_height() - 1:
				return

			image.lock()
			color = image.get_pixelv(position)
			image.unlock()
		Mode.PICK_COORDINATE:
			color.r8 = position.x
			color.g8 = position.y

	var button := BUTTON_LEFT if _color_slot == 0 else BUTTON_RIGHT
	Tools.assign_color(color, button, false)


func _on_Mode_item_selected(index: int) -> void:
	pick_mode = index
	if pick_mode == Mode.PICK_COLOR:
		$ColorPicker/Mode.hint_tooltip = "Picks actual Color from the Image"
	elif pick_mode == Mode.PICK_COORDINATE:
		$ColorPicker/Mode.hint_tooltip = "Returns current position as a color"


func _on_Tweak_value_changed(value: float, R_G_B: String) -> void:
	var button = _color_slot + 1
	var color: Color = Tools.get_assigned_color(button)
	if R_G_B == "R":
		color.r8 = value
	elif R_G_B == "G":
		color.g8 = value
	elif R_G_B == "B":
		color.b8 = value
	elif R_G_B == "A":
		color.a8 = value
	Tools.assign_color(color, button, false)

