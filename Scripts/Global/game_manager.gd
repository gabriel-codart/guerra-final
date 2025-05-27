extends Node

var area_test: PackedScene = preload("res://Scenes/Areas/area_test.tscn")
# Telas
var main_menu: PackedScene = preload("res://Scenes/UI/main_menu.tscn")
var pause_menu: PackedScene = preload("res://Scenes/UI/pause_menu.tscn")
var game_over: PackedScene = preload("res://Scenes/UI/game_over.tscn")
# Levels
var level_1: PackedScene = preload("res://Scenes/Areas/level_1.tscn")
var level_2: PackedScene = preload("res://Scenes/Areas/level_2.tscn")

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 1.00))

func transition_to_scene(scene: PackedScene) -> void:
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_packed(scene)
	get_tree().paused = false

func start_game() -> void:
	transition_to_scene(level_1)

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

func go_to_next_level() -> void:
	transition_to_scene(level_2)
