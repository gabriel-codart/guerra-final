extends CanvasLayer


func _ready() -> void:
	# Carrega Música
	MusicPlayer.play_music("Cutscene")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		go_to_next_scene()

func go_to_next_scene() -> void:
	PlayerManager.current_progress += 1
	GameManager.go_to_next_scene()
