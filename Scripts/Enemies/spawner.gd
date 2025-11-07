extends Node2D

class_name EnemySpawner

@export var enemy_scene: PackedScene
@export var spawn_interval: float = 3.0        # tempo entre os spawns
@export var batch_cooldown: float = 15.0        # tempo entre as levas de spawns
@export var initial_delay: float = 2.0      # tempo para começar a spawnar (await timer)
@export var max_enemies: int = 5               # número máximo simultâneo (opcional)

var can_spawn: bool = false
var active_enemies: Array = []

@onready var cooldown_timer: Timer = $BatchCooldown

func _ready() -> void:
	if enemy_scene == null:
		push_warning("EnemySpawner sem cena de inimigo atribuída.")
		return
	# Configura o timer
	cooldown_timer.autostart = false
	cooldown_timer.one_shot = true

# ===================================
# Inicia o sistema de spawn após um delay inicial
# ===================================
func start_after_delay() -> void:
	cooldown_timer.wait_time = initial_delay
	cooldown_timer.start()

func stop_spawn() -> void:
	cooldown_timer.stop()

# ===================================
# Spawna um inimigo e controla a lista de instâncias
# ===================================
func _on_cooldown_timer_timeout() -> void:
	# Verifica se o protagonista está por perto
	if not can_spawn:
		return
	# Verifica se o número de inimigos já está no limite
	active_enemies = active_enemies.filter(func(e): return is_instance_valid(e))
	if active_enemies.size() >= max_enemies:
		return
	# Se estiver tudo certo, ele começa a spawnar
	var i: int = 0
	while i < max_enemies:
		# Atualiza lista e verifica limite
		active_enemies = active_enemies.filter(func(e): return is_instance_valid(e))
		# Verifica o limite de inimigos
		if active_enemies.size() >= max_enemies:
			break
		# Verifica se pode continuar spawnando
		if not can_spawn:
			break
		spawn_enemy()
		await get_tree().create_timer(spawn_interval).timeout
		i += 1
	# Reinicia o cooldwon com o tempo de batch
	cooldown_timer.wait_time = batch_cooldown
	cooldown_timer.start()

func spawn_enemy() -> void:
	# Instancia inimigo
	var enemy_instance = enemy_scene.instantiate()
	get_parent().add_child(enemy_instance)
	enemy_instance.global_position = global_position  # spawna na posição do próprio spawner
	# Guarda referência
	active_enemies.append(enemy_instance)
	# Remove da lista ao morrer (se o inimigo tiver sinal 'dead')
	if enemy_instance.has_signal("dead"):
		enemy_instance.dead.connect(func(): active_enemies.erase(enemy_instance))

# -------------------------------
# Manipula a variável can_spawn
# -------------------------------
func _on_area_2d_body_entered(_body: Node2D) -> void:
	if can_spawn == false:
		can_spawn = true
	# Inicia o spawn loop
	start_after_delay()

func _on_area_2d_body_exited(_body: Node2D) -> void:
	if can_spawn == true:
		can_spawn = false
	# Pausa o spawn loop
	stop_spawn()
