extends CanvasLayer

@onready var continue_game_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ContinueGameButton
@onready var settings_menu: PackedScene = preload("res://Scenes/UI/settings_menu.tscn")

func _ready():
	MusicPlayer.play_music("MainMenu")
	
	if PlayerManager.current_progress == 1:
		continue_game_button.disabled = true

func _on_continue_game_button_pressed():
	GameManager.continue_game()
	queue_free()

func _on_new_game_button_pressed():
	GameManager.new_game()
	queue_free()

func _on_settings_button_pressed():
	var settings_menu_instance = settings_menu.instantiate()
	get_tree().get_root().add_child(settings_menu_instance)

func _on_exit_button_pressed():
	GameManager.exit_game()
