extends CanvasLayer

@onready var window_mode_option_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/WindowModeOptionButton
@onready var brightness_slider = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BrightContainer/HSlider
@onready var volume_slider = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VolumeContainer/HSlider

var window_modes: Dictionary = {"Fullscreen": DisplayServer.WINDOW_MODE_FULLSCREEN,
								"Windowed": DisplayServer.WINDOW_MODE_WINDOWED,
								"Window Maximized": DisplayServer.WINDOW_MODE_MAXIMIZED}

func _ready() -> void:
	for window_mode in window_modes:
		window_mode_option_button.add_item(window_mode)
	
	initialise_controls()

func initialise_controls() -> void:
	SettingsManager.load_settings()
	var settings_data: SettingsDataResource = SettingsManager.get_settings()
	window_mode_option_button.selected = settings_data.window_mode_index
	brightness_slider.value = settings_data.brightness
	volume_slider.value = settings_data.volume

func _on_window_mode_option_button_item_selected(index):
	var window_mode = window_modes.get(window_mode_option_button.get_item_text(index)) as int
	SettingsManager.set_window_mode(window_mode, index)

func _on_brightness_slider_value_changed(value):
	SettingsManager.set_brightness(value)

func _on_audio_slider_value_changed(value):
	SettingsManager.set_volume(value)

func _on_back_button_pressed():
	SettingsManager.save_settings()
	queue_free()
