extends Node

var area_test: PackedScene = preload("res://Scenes/Areas/area_test.tscn")

var main_menu: PackedScene = preload("res://Scenes/UI/main_menu.tscn")
var pause_menu: PackedScene = preload("res://Scenes/UI/pause_menu.tscn")
var level_1: PackedScene = preload("res://Scenes/Areas/level_1.tscn")

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.26, 0.10, 0.0, 1.00))

func start_game() -> void:
	transition_to_scene(level_1)

func exit_game() -> void:
	get_tree().quit()

func menu_game() -> void:
	transition_to_scene(main_menu)

func pause_game() -> void:
	get_tree().paused = true
	var pause_menu_instance = pause_menu.instantiate()
	get_tree().get_root().add_child(pause_menu_instance)

func transition_to_scene(scene: PackedScene) -> void:
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_packed(scene)
	get_tree().paused = false
