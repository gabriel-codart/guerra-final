extends CanvasLayer

@onready var skip_button: Button = $JumpCutContainer/PanelContainer/MarginContainer/SkipButton

func _ready() -> void:
	# Carrega Música
	MusicPlayer.play_music("MainMenu")
	# Conecta o botão de skip (caso ainda não esteja conectado)
	if not skip_button.pressed.is_connected(_on_skip_button_pressed):
		skip_button.pressed.connect(_on_skip_button_pressed)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		go_to_main_menu()

func go_to_main_menu() -> void:
	# --- Troca para o menu principal ---
	GameManager.go_to_main_menu()

func _on_skip_button_pressed() -> void:
	go_to_main_menu()
