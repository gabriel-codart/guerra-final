extends Node

var area_test: PackedScene = preload("res://Scenes/Areas/area_test.tscn")

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.99, 0.26, 0.02, 1.00))

func start_game() -> void:
	transition_to_scene(area_test.resource_path)

func exit_game() -> void:
	get_tree().quit()

func transition_to_scene(scene_path: String) -> void:
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(scene_path)
