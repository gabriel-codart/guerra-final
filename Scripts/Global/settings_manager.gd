extends Node

var settings_data: SettingsDataResource

var save_settings_path = "user://game_data/"
var save_file_name = "settings_data.tres"

func load_settings() -> void:
	if !DirAccess.dir_exists_absolute(save_settings_path):
		DirAccess.make_dir_absolute(save_settings_path)
	
	if ResourceLoader.exists(save_settings_path + save_file_name):
		settings_data = ResourceLoader.load(save_settings_path + save_file_name)
	
	if settings_data == null:
		settings_data = SettingsDataResource.new()
	
	if settings_data != null:
		set_window_mode(settings_data.window_mode, settings_data.window_mode_index)
		set_brightness(settings_data.brightness)
		set_volume(settings_data.volume)

func set_window_mode(window_mode: int, window_mode_index: int) -> void:
	match window_mode:
		DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.WINDOW_MODE_MAXIMIZED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		_:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	settings_data.window_mode = window_mode
	settings_data.window_mode_index = window_mode_index

func set_brightness(value: int) -> void:
	if get_tree().root.has_node("BrightnessLayer"):
		var layer = get_tree().root.get_node("BrightnessLayer")
		var black_rect: ColorRect = layer.get_node("ColorRectBlack")
		var white_rect: ColorRect = layer.get_node("ColorRectWhite")
		
		# Reseta opacidades
		black_rect.color.a = 0.0
		white_rect.color.a = 0.0
		
		if value < 50:
			var strength = 50 - value
			black_rect.color.a = strength * 0.2 / 50
		elif value > 50:
			var strength = value - 50
			white_rect.color.a = strength * 0.2 / 50
	
	settings_data.brightness = value

func set_volume(value: int) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	
	if value == 0:
		AudioServer.set_bus_mute(bus_index, true) # Muta o som
	else:
		AudioServer.set_bus_mute(bus_index, false) # Desmuta
		var min_db = -40.0
		var max_db = 5.0
		var t = clamp(value / 100.0, 0.0, 1.0)
		var db_value = lerp(min_db, max_db, t)
		AudioServer.set_bus_volume_db(bus_index, db_value)
	
	settings_data.volume = value

func get_settings() -> SettingsDataResource:
	return settings_data

func save_settings() -> void:
	ResourceSaver.save(settings_data, save_settings_path + save_file_name)
