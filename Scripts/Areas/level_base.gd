extends Node2D

class_name LevelBase

@export_multiline var initial_text: String
@export var key_to_next_level: Keys.Type
@export var level_type: Scenes.Type

@onready var next_level_area: Area2D = $NextLevelArea
@onready var HUD: CanvasLayer = $HUD
@onready var protagonist: CharacterBody2D = $Protagonist
@onready var key_names = Keys.NAMES

func _ready() -> void:
	HUD.set_text(initial_text)
	
	# Carrega Música
	if level_type == Scenes.Type.LevelCommon:
		MusicPlayer.play_music("LevelCommon")
	elif level_type == Scenes.Type.LevelBoss:
		MusicPlayer.play_music("LevelBoss")
	
	# Conectar next level area
	if not next_level_area.body_entered.is_connected(_on_next_level_area_body_entered):
		next_level_area.body_entered.connect(_on_next_level_area_body_entered)

func set_HUD_text(text: String) -> void:
	HUD.set_text(text)

func can_go_to_next_scene() -> bool:
	return protagonist.current_key == key_to_next_level or key_to_next_level == Keys.Type.Empty

func go_to_next_scene() -> void:
	if not can_go_to_next_scene():
		set_HUD_text("Preciso de uma chave " + key_names[key_to_next_level].to_upper() + " para seguir em frente.")
		return
	# --- Atualiza dados do progresso atual ---
	var save_data = ProgressManager.get_current_save()
	if save_data:
		save_data.player_health = protagonist.health
		save_data.player_weapon = protagonist.current_weapon
		save_data.player_progress += 1
		ProgressManager.save_current_progress() # grava no arquivo
		# Alerta opcional de feedback visual
		AlertManager.show_alert("Level salvo!", AlertManager.AlertType.SUCCESS)
	else:
		push_error("Nenhum progresso ativo no ProgressManager!")
	# --- Troca de cena ---
	GameManager.load_current_progress_scene()

func _on_next_level_area_body_entered(body):
	if body.is_in_group("Protagonist"):
		go_to_next_scene()

func _on_next_level_area_body_exited(body):
	if body.is_in_group("Protagonist"):
		set_HUD_text("")
