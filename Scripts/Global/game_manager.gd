extends Node

var area_test: PackedScene = preload("res://Scenes/Areas/area_test.tscn")
# Menus
var main_menu: PackedScene = preload("res://Scenes/UI/main_menu.tscn")
var progress_menu: PackedScene = preload("res://Scenes/UI/progress_menu.tscn")
var pause_menu: PackedScene = preload("res://Scenes/UI/pause_menu.tscn")
var game_over: PackedScene = preload("res://Scenes/UI/game_over.tscn")
# Tela de Transição
@onready var transition_layer = preload("res://Scenes/UI/transition_layer.tscn").instantiate()
# Camada de Brilho
@onready var brightness_layer = preload("res://Scenes/UI/brightness_layer.tscn").instantiate()

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 1.00))
	# Adiciona a transição
	get_tree().root.add_child.call_deferred(transition_layer)
	# Layer global para brilho
	get_tree().root.add_child.call_deferred(brightness_layer)
	#brightness_layer.name = "BrightnessLayer"
	# Carrega as configs do usuário
	SettingsManager.load_settings()

func transition_to_scene(scene: PackedScene) -> void:
	get_tree().paused = false
	transition_layer.play_transition(scene)

func load_current_progress_scene() -> void:
	var scene_id = Scenes.PROGRESS_SCENE_MAP.get(ProgressManager.current_save.player_progress, null)
	if scene_id == null:
		print("Progresso inválido:", ProgressManager.current_save.player_progress)
		return
	
	var scene = Scenes.get_scene(scene_id)
	if scene:
		transition_to_scene(scene)
	else:
		print("Cena não encontrada para ID:", scene_id)
		go_to_main_menu()

func exit_game() -> void:
	get_tree().quit()

func go_to_main_menu() -> void:
	transition_to_scene(main_menu)

func go_to_progress_menu() -> void:
	transition_to_scene(progress_menu)

func go_to_pause_menu() -> void:
	get_tree().paused = true
	var pause_menu_instance = pause_menu.instantiate()
	get_tree().get_root().add_child(pause_menu_instance)

func go_to_game_over() -> void:
	get_tree().paused = true
	var game_over_instance = game_over.instantiate()
	get_tree().get_root().add_child(game_over_instance)
