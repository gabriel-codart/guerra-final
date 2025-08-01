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
	if protagonist.current_key == key_to_next_level or key_to_next_level == Keys.Type.Empty:
		return true
	else:
		return false

func go_to_next_scene() -> void:
	if can_go_to_next_scene():
		PlayerManager.health = protagonist.health
		PlayerManager.current_weapon = protagonist.current_weapon
		PlayerManager.current_key = Keys.Type.Empty
		PlayerManager.current_progress += 1
		GameManager.go_to_next_scene()
	else:
		set_HUD_text("Preciso de uma chave " + key_names[key_to_next_level].to_upper() + " para seguir em frente.")

func _on_next_level_area_body_entered(body):
	if body.is_in_group("Protagonist"):
		go_to_next_scene()

func _on_next_level_area_body_exited(body):
	if body.is_in_group("Protagonist"):
		set_HUD_text("")
