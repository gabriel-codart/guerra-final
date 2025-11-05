extends CanvasLayer

@onready var skip_button: Button = $JumpCutContainer/PanelContainer/MarginContainer/SkipButton
@export var save_next: bool = false

func _ready() -> void:
	# Carrega Música
	MusicPlayer.play_music("Cutscene")
	# Conecta o botão de skip (caso ainda não esteja conectado)
	if not skip_button.pressed.is_connected(_on_skip_button_pressed):
		skip_button.pressed.connect(_on_skip_button_pressed)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		go_to_next_scene()

func save_progress() -> void:
	# --- Atualiza dados do progresso atual ---
	if ProgressManager.current_save == null:
		AlertManager.show_alert("Nenhum progresso ativo!", AlertManager.AlertType.ERROR)
		push_error("Nenhum progresso ativo no ProgressManager!")
		return
	ProgressManager.save_current_progress() # grava no arquivo
	# Alerta opcional de feedback visual
	AlertManager.show_alert("Level salvo!", AlertManager.AlertType.SUCCESS)

func go_to_next_scene() -> void:
	if ProgressManager.current_save == null:
		AlertManager.show_alert("Nenhum progresso ativo!", AlertManager.AlertType.ERROR)
		push_error("Nenhum progresso ativo no ProgressManager!")
		return
	# --- Avança progresso atual ---
	ProgressManager.current_save.player_progress += 1
	AlertManager.show_alert("Carregando...")
	# Salva progresso
	if save_next:
		save_progress()
	# --- Troca de cena ---
	GameManager.load_current_progress_scene()

func _on_skip_button_pressed() -> void:
	go_to_next_scene()
