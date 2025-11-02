extends CanvasLayer

@onready var progress_menu: PackedScene = preload("res://Scenes/UI/progress_menu.tscn")
@onready var settings_menu: PackedScene = preload("res://Scenes/UI/settings_menu.tscn")

func _ready():
	MusicPlayer.play_music("MainMenu")

func _on_new_game_button_pressed():
	GameManager.go_to_progress_menu()
	await get_tree().create_timer(2.5).timeout
	queue_free()

func _on_settings_button_pressed():
	var settings_menu_instance = settings_menu.instantiate()
	get_tree().get_root().add_child.call_deferred(settings_menu_instance)

func _on_exit_button_pressed():
	GameManager.exit_game()
