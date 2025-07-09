extends CanvasLayer


func _ready():
	# Carrega Música
	MusicPlayer.play_music("Cutscene")

func go_to_next_scene() -> void:
	PlayerManager.current_progress += 1
	GameManager.go_to_next_scene()
