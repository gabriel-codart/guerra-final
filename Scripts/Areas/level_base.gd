extends Node2D

class_name LevelBase

@export_multiline var initial_text: String
@export var key_to_next_level: Keys.Type
@export var level_type: Scenes.Type
#@export var save_init: bool = true

@onready var next_level_area: Area2D = $NextLevelArea if has_node("NextLevelArea") else null
@onready var HUD: CanvasLayer = $HUD
@onready var protagonist: CharacterBody2D = $Protagonist
@onready var boss: Node = $Boss if has_node("Boss") else null
@onready var key_names = Keys.NAMES

func _ready() -> void:
	HUD.set_text(initial_text)
	# Carrega música de acordo com o tipo de level
	match level_type:
		Scenes.Type.LevelCommon:
			MusicPlayer.play_music("LevelCommon")
		Scenes.Type.LevelBoss:
			MusicPlayer.play_music("LevelBoss")
	# Conectar dependendo do tipo de level
	if level_type == Scenes.Type.LevelCommon and next_level_area:
		if not next_level_area.body_entered.is_connected(_on_next_level_area_body_entered):
			next_level_area.body_entered.connect(_on_next_level_area_body_entered)
	elif level_type == Scenes.Type.LevelBoss and boss:
		if not boss.has_signal("dead"):
			push_warning("O Boss não possui o sinal 'dead'. Verifique o script do Boss.")
		else:
			if not boss.dead.is_connected(_on_boss_dead):
				boss.dead.connect(_on_boss_dead)

func set_HUD_text(text: String) -> void:
	HUD.set_text(text)

func can_go_to_next_scene() -> bool:
	return protagonist.current_key == key_to_next_level or key_to_next_level == Keys.Type.Empty

#func save_progress() -> void:
	#if ProgressManager.current_save == null:
		#AlertManager.show_alert("Nenhum progresso ativo!", AlertManager.AlertType.ERROR)
		#push_error("Nenhum progresso ativo no ProgressManager!")
		#return
	#
	#ProgressManager.save_current_progress()
	#AlertManager.show_alert("Level salvo!", AlertManager.AlertType.SUCCESS)

func go_to_next_scene() -> void:
	if level_type == Scenes.Type.LevelCommon and not can_go_to_next_scene():
		set_HUD_text("Preciso de uma chave " + key_names[key_to_next_level].to_upper() + " para seguir em frente.")
		return
	
	if ProgressManager.current_save == null:
		AlertManager.show_alert("Nenhum progresso ativo!", AlertManager.AlertType.ERROR)
		push_error("Nenhum progresso ativo no ProgressManager!")
		return
	
	# Atualiza progresso
	ProgressManager.current_save.player_health = protagonist.health
	ProgressManager.current_save.player_weapon = protagonist.current_weapon
	ProgressManager.current_save.player_progress += 1
	
	GameManager.load_current_progress_scene()

# ======== HANDLERS ========

func _on_next_level_area_body_entered(body):
	if body.is_in_group("Protagonist"):
		go_to_next_scene()

func _on_next_level_area_body_exited(body):
	if body.is_in_group("Protagonist"):
		set_HUD_text("")

func _on_boss_dead() -> void:
	go_to_next_scene()
