extends CanvasLayer

@onready var skip_button: Button = $JumpCutContainer/PanelContainer/MarginContainer/SkipButton

func _ready() -> void:
	# Carrega Música
	MusicPlayer.play_music("Cutscene")
	# Conecta o botão de skip (caso ainda não esteja conectado)
	if not skip_button.pressed.is_connected(_on_skip_button_pressed):
		skip_button.pressed.connect(_on_skip_button_pressed)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		go_to_next_scene()

func go_to_next_scene() -> void:
	if ProgressManager.current_save == null:
		push_error("Nenhum progresso ativo no ProgressManager!")
		return
	# --- Atualiza dados do progresso atual ---
	ProgressManager.current_save.player_progress += 1
	AlertManager.show_alert("Carregando...")
	# --- Troca de cena ---
	GameManager.load_current_progress_scene()

func _on_skip_button_pressed() -> void:
	go_to_next_scene()
