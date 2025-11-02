extends Node

const SAVE_PATH := "user://saves/"
const SAVE_FILE_PREFIX := "save_slot_"
const SAVE_FILE_EXTENSION := ".tres"

# Dicionário contendo todos os saves carregados na memória
var saves: Dictionary = {}

# Progresso atualmente carregado (em uso no jogo)
var current_save: ProgressDataResource = null

func _ready() -> void:
	load_all_saves()

# --- Carregar todos os saves existentes ---
func load_all_saves() -> void:
	if not DirAccess.dir_exists_absolute(SAVE_PATH):
		DirAccess.make_dir_absolute(SAVE_PATH)
	
	saves.clear()
	
	var dir := DirAccess.open(SAVE_PATH)
	if dir:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			if file_name.ends_with(SAVE_FILE_EXTENSION):
				var full_path := SAVE_PATH + file_name
				var save_data := ResourceLoader.load(full_path)
				if save_data and save_data is ProgressDataResource:
					saves[file_name] = save_data
			file_name = dir.get_next()
		dir.list_dir_end()

# --- Sanitiza nome de arquivo ---
func sanitize_filename(name_value: String) -> String:
	var s := name_value.strip_edges()
	s = s.replace(" ", "_")
	# 1. Cria uma nova instância da classe RegEx.
	var regex := RegEx.new()
	# 2. Compila a expressão regular.
	var error = regex.compile("[^A-Za-z0-9_\\-]")
	# Opcional: Verificar se a compilação foi bem-sucedida (o que é bom)
	if error != OK:
		print("Erro ao compilar a RegEx: ", error)
		# Você pode retornar a string não completamente sanitizada ou lançar um erro
		return s
	# 3. Usa o método sub(string_alvo, string_substituta, todos_os_matches)
	return regex.sub(s, "", true)

# --- Criar novo save ---
func create_new_save(slot_name: String, data: ProgressDataResource) -> void:
	if not DirAccess.dir_exists_absolute(SAVE_PATH):
		DirAccess.make_dir_absolute(SAVE_PATH)
	
	var timestamp = Time.get_datetime_string_from_system()
	data.timestamp = timestamp
	data.slot_name = slot_name
	
	# Gera filename a partir do slot_name para facilitar gerenciamento
	var base = sanitize_filename(slot_name)
	var i = 1
	var save_file_name = SAVE_FILE_PREFIX + (base if base != "" else str(len(saves)+1)) + SAVE_FILE_EXTENSION
	# se o nome já existir, acrescenta sufixo numérico
	while FileAccess.file_exists(SAVE_PATH + save_file_name):
		i += 1
		save_file_name = SAVE_FILE_PREFIX + (base if base != "" else str(len(saves)+1)) + "_" + str(i) + SAVE_FILE_EXTENSION
	# Monta o caminho do arquivo + nome do arquivo
	var save_path = SAVE_PATH + save_file_name
	
	var result = ResourceSaver.save(data, save_path)
	if result == OK:
		saves[save_file_name] = data
		current_save = data
	else:
		push_error("Erro ao salvar progresso: %s" % save_file_name)

# --- Atualizar save existente ---
func update_save(file_name: String, updated_data: ProgressDataResource) -> void:
	if not saves.has(file_name):
		push_error("Save não encontrado: %s" % file_name)
		return
	
	updated_data.timestamp = Time.get_datetime_string_from_system()
	var result = ResourceSaver.save(updated_data, SAVE_PATH + file_name)
	if result == OK:
		saves[file_name] = updated_data
	else:
		push_error("Erro ao atualizar save: %s" % file_name)

# --- Carregar um save específico ---
func load_save(file_name: String) -> void:
	if not saves.has(file_name):
		push_error("Save não encontrado: %s" % file_name)
		return
	
	current_save = saves[file_name]

# --- Deletar save ---
func delete_save(file_name: String) -> void:
	if not saves.has(file_name):
		push_error("Save não encontrado: %s" % file_name)
		return
	
	var result = DirAccess.remove_absolute(SAVE_PATH + file_name)
	if result == OK:
		saves.erase(file_name)
	else:
		push_error("Erro ao deletar save: %s" % file_name)

# --- Obter lista de saves (para a UI) ---
func get_all_saves() -> Array:
	var list: Array = []
	for file_name in saves.keys():
		list.append(saves[file_name])
	return list

# --- Obter save atual ---
func get_current_save() -> ProgressDataResource:
	return current_save

# --- Salvar progresso atual ---
func save_current_progress() -> void:
	if current_save == null:
		push_error("Nenhum save ativo para atualizar!")
		return
	
	update_save(get_current_save_file_name(), current_save)

# --- Retorna o nome do arquivo do save atual ---
func get_current_save_file_name() -> String:
	for file_name in saves.keys():
		if saves[file_name] == current_save:
			return file_name
	return ""
