extends Node2D

class_name EnemySpawner

@export var enemy_scene: PackedScene
@export var spawn_interval: float = 5.0        # tempo entre spawns
@export var initial_delay: float = 120.0       # tempo para começar a spawnar (await timer)
@export var max_enemies: int = 5               # número máximo simultâneo (opcional)

var active_enemies: Array = []

@onready var spawn_timer: Timer = Timer.new()

func _ready() -> void:
	if enemy_scene == null:
		push_warning("EnemySpawner sem cena de inimigo atribuída.")
		return

	# Configura o timer
	spawn_timer.wait_time = spawn_interval
	spawn_timer.autostart = false
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)

	# Inicia o spawner após o tempo inicial
	start_after_delay(initial_delay)

# ===================================
# Inicia o sistema de spawn após um delay inicial
# ===================================
func start_after_delay(delay: float) -> void:
	await get_tree().create_timer(delay).timeout
	spawn_timer.start()

# ===================================
# Spawna um inimigo e controla a lista de instâncias
# ===================================
func _on_spawn_timer_timeout() -> void:
	# Verifica limite
	active_enemies = active_enemies.filter(func(e): return is_instance_valid(e))
	if active_enemies.size() >= max_enemies:
		return

	# Instancia inimigo
	var enemy_instance = enemy_scene.instantiate()
	get_parent().add_child(enemy_instance)
	enemy_instance.global_position = global_position  # spawna na posição do próprio spawner

	# Guarda referência
	active_enemies.append(enemy_instance)

	# Remove da lista ao morrer (se o inimigo tiver sinal 'dead')
	if enemy_instance.has_signal("dead"):
		enemy_instance.dead.connect(func(): active_enemies.erase(enemy_instance))
