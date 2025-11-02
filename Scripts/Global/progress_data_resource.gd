extends Resource
class_name ProgressDataResource

# Dados do progresso (são exportados para serem serializados)
@export var player_health: int = 2
@export var player_weapon: int = 0
@export var player_progress: int = 1

# Metadados (úteis para UI)
@export var slot_name: String = "Save"
@export var timestamp: String = "" # string legível (ex: "2025-11-01 18:00")
