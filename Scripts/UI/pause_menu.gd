extends CanvasLayer

var can_process_input := false

func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	can_process_input = true

func _process(_delta: float) -> void:
	if can_process_input and Input.is_action_just_pressed("esc"):
		resume_game()

func resume_game() -> void:
	get_tree().paused = false
	queue_free()

func _on_resume_button_pressed():
	resume_game()

func _on_main_menu_button_pressed():
	GameManager.go_to_main_menu()
	queue_free()
