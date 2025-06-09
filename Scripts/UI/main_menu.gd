extends CanvasLayer

@onready var continue_game_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ContinueGameButton

func _ready():
	if PlayerManager.current_progress == 1:
		continue_game_button.disabled = true

func _on_continue_game_button_pressed():
	GameManager.continue_game()
	queue_free()

func _on_new_game_button_pressed():
	GameManager.new_game()
	queue_free()

func _on_exit_button_pressed():
	GameManager.exit_game()
