extends Node

var current_music: String = ""

func stop_all_music() -> void:
	for child in get_children():
		if child is AudioStreamPlayer:
			child.stop()

func play_music(name_value: String) -> void:
	if name_value == current_music:
		return # Aqui verifica se a música já está tocando
	stop_all_music()
	var player = get_node_or_null(name_value)
	if player and player is AudioStreamPlayer:
		player.play()
		current_music = name_value
