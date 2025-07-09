extends Node

var area_test: PackedScene = preload("res://Scenes/Areas/area_test.tscn")
# Telas
var main_menu: PackedScene = preload("res://Scenes/UI/main_menu.tscn")
var pause_menu: PackedScene = preload("res://Scenes/UI/pause_menu.tscn")
var game_over: PackedScene = preload("res://Scenes/UI/game_over.tscn")

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 1.00))
	
	SettingsManager.load_settings()

func transition_to_scene(scene: PackedScene) -> void:
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_packed(scene)
	get_tree().paused = false

func load_current_scene() -> void:
	var scene_id = Scenes.PROGRESS_SCENE_MAP.get(PlayerManager.current_progress, null)
	if scene_id == null:
		print("Progresso inválido:", PlayerManager.current_progress)
		return
	
	var scene = Scenes.get_scene(scene_id)
	if scene:
		transition_to_scene(scene)
	else:
		print("Cena não encontrada para ID:", scene_id)
		go_to_main_menu()

func continue_game() -> void:
	load_current_scene()

func new_game() -> void:
	PlayerManager.current_progress = 1
	load_current_scene()

func exit_game() -> void:
	get_tree().quit()

func go_to_main_menu() -> void:
	transition_to_scene(main_menu)

func go_to_pause_menu() -> void:
	get_tree().paused = true
	var pause_menu_instance = pause_menu.instantiate()
	get_tree().get_root().add_child(pause_menu_instance)

func go_to_game_over() -> void:
	get_tree().paused = true
	var game_over_instance = game_over.instantiate()
	get_tree().get_root().add_child(game_over_instance)

func go_to_next_scene() -> void:
	load_current_scene()
