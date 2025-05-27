extends CanvasLayer

func _ready() -> void:
	pass # Replace with function body.

func _on_restart_level_button_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false
	queue_free()

func _on_main_menu_button_pressed():
	GameManager.go_to_main_menu()
	queue_free()
