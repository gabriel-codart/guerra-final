extends CanvasLayer

# Container de listagem de progressos
@onready var saves_list: VBoxContainer = $MarginContainer/HBoxContainer/PanelSaves/MarginContainer/VBoxContainer/ScrollContainer/Saves
# Nome de Novo Progresso
@onready var new_game_name: LineEdit = $MarginContainer/HBoxContainer/PanelNewGame/MarginContainer/VBoxContainer/NewGameName
# Botão de Novo Progresso
@onready var new_game_button: Button = $MarginContainer/HBoxContainer/PanelNewGame/MarginContainer/VBoxContainer/NewGameButton

func _ready() -> void:
	new_game_button.disabled = new_game_name.text.strip_edges().is_empty()
	render_saves_list()

# ========================
# Renderiza a lista de saves
# ========================
func render_saves_list() -> void:
	queue_free_children(saves_list) # limpa lista antiga
	
	var saves = ProgressManager.get_all_saves()
	if saves.is_empty():
		var label := Label.new()
		label.text = "Nenhum progresso encontrado."
		label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
		label.add_theme_font_size_override("font_size", 10)
		saves_list.add_child(label)
		return
	
	for file_name in ProgressManager.saves.keys():
		var save_data = ProgressManager.saves[file_name]
		
		var hbox := HBoxContainer.new()
		hbox.custom_minimum_size.y = 32
		
		# --- Botão de carregar ---
		var load_button := Button.new()
		load_button.text = "%s\n%s" % [save_data.slot_name, save_data.timestamp]
		load_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		load_button.add_theme_font_size_override("font_size", 10)
		load_button.connect("pressed", Callable(self, "_on_load_button_pressed").bind(file_name))
		hbox.add_child(load_button)
		
		# --- Botão de excluir ---
		var delete_button := Button.new()
		delete_button.text = "x"
		delete_button.add_theme_font_size_override("font_size", 16)
		delete_button.custom_minimum_size.x = 32
		delete_button.connect("pressed", Callable(self, "_on_delete_button_pressed").bind(file_name))
		hbox.add_child(delete_button)
	
		saves_list.add_child(hbox)

# ========================
# Botões
# ========================
func _on_main_menu_button_pressed() -> void:
	GameManager.go_to_main_menu()
	await get_tree().create_timer(2.5).timeout
	queue_free()

func _on_load_button_pressed(file_name: String) -> void:
	ProgressManager.load_save(file_name)
	AlertManager.show_alert("Carregando...")
	GameManager.load_current_progress_scene()
	await get_tree().create_timer(2.5).timeout
	queue_free()

func _on_delete_button_pressed(file_name: String) -> void:
	# Pergunta se quer realmente deletar
	var confirmed = await DialogManager.show_dialog(
		"Deletar Progresso",
		"Deseja realmente deletar seu progresso?",
		"Sim, deletar",
		"Não, voltar"
	)
	if not confirmed:
		print("O jogador cancelou a deleção.")
		return
	# Deleta o progresso
	ProgressManager.delete_save(file_name)
	render_saves_list() # atualiza lista após exclusão
	AlertManager.show_alert("Progresso deletado!")

func _on_new_game_button_pressed():
	create_new_game_progress()
	GameManager.load_current_progress_scene()
	await get_tree().create_timer(2.5).timeout
	queue_free()

# ========================
# Novo progresso
# ========================
func _on_new_game_name_text_changed(new_text: String) -> void:
	if new_text.strip_edges().is_empty():
		new_game_button.disabled = true
		return
	# --- Verifica se nome já existe ---
	for save_data in ProgressManager.get_all_saves():
		if save_data.slot_name.to_lower() == new_text.to_lower():
			new_game_button.disabled = true
			AlertManager.show_alert("Já existe um progresso com esse nome!", AlertManager.AlertType.WARNING)
			return
	new_game_button.disabled = false

func create_new_game_progress() -> void:
	var name_text = new_game_name.text.strip_edges()
	if name_text.is_empty():
		return
	# Cria novo save
	var new_save := ProgressDataResource.new()
	new_save.player_health = 2
	new_save.player_weapon = 0
	new_save.player_progress = 1
	new_save.slot_name = name_text
	
	ProgressManager.create_new_save(name_text, new_save)
	ProgressManager.load_save(ProgressManager.get_current_save_file_name()) # carrega automaticamente o novo save
	
	new_game_name.text = ""
	new_game_button.disabled = true
	render_saves_list()
	
	AlertManager.show_alert("Novo progresso...")

# ========================
# Utilitário
# ========================
func queue_free_children(container: Node) -> void:
	for child in container.get_children():
		child.queue_free()
