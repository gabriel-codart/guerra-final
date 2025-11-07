extends EnemyBoss

# Marcador de Posição
@onready var drop_marker: Marker2D = $DropMarker2D
# SFX
@onready var sfx: Node = $SFX
# Variáveis de patrulha
var current_point_index: int = 0
# Controle geral
var searching_prota: bool = true
# Drop de inimigos
@export var zombie_man_scene: PackedScene = preload("res://Scenes/Enemies/zombie_man.tscn")
@export var zombie_woman_scene: PackedScene = preload("res://Scenes/Enemies/zombie_woman.tscn")
@export var zombies_to_drop: int = 3
# Damage Area
@onready var damage_area: Area2D = $DamageArea2D
# Configuração de vulnerabilidade
@onready var vulnerable_timer: Timer = $VulnerableTimer
@export var vulnerable_time: float = 30.0

func _ready() -> void:
	super._ready()
	SCALE = 1.5
	# Conectar damage area
	if not damage_area.body_entered.is_connected(_on_damage_area_2d_body_entered):
		damage_area.body_entered.connect(_on_damage_area_2d_body_entered)
	# Conectar vulnerable timer
	if not vulnerable_timer.timeout.is_connected(_on_vulnerable_timer_timeout):
		vulnerable_timer.timeout.connect(_on_vulnerable_timer_timeout)

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	enemy_gravity(delta)
	enemy_idle(delta)
	enemy_walk(delta)
	move_and_slide()
	enemy_animate()

func enemy_gravity(_delta: float) -> void:
	pass # Não possui gravidade

# --- Movimentation ---
func enemy_walk(delta: float) -> void:
	if not can_act():
		return
	
	if number_of_points > 0:
		go_to_patrol(delta)
	
	if can_walk:
		transform.x.x = direction.x * SCALE

func go_to_patrol(delta: float) -> void:
	check_direction(current_point)
	if abs(position.x - current_point.x) > 0.5:
		velocity.x = direction.x * speed * delta
		set_state(States.Enemy.Walk)
	else:
		current_point_position = (current_point_position + 1) % number_of_points
		current_point = point_positions[current_point_position]
		check_direction(current_point)
		can_walk = false
		timer.start(1.0)

func check_direction(target_point: Vector2) -> void:
	direction = Vector2.RIGHT if target_point.x > global_position.x else Vector2.LEFT

# --- Attacking ---
func perform_drop_zombies() -> void:
	if is_attacking or not can_act():
		return
	set_state(States.Enemy.Special)
	is_attacking = true
	can_walk = false
	# Inicia o processo de drop com coroutine
	await get_tree().create_timer(1.0).timeout  # pequena pausa antes de começar a soltar
	var total_zombies = zombies_to_drop * phase
	for i in range(total_zombies):
		anim_sprite.play("drop")
		enemy_sfx("drop")
		drop_random_zombie()
		await get_tree().create_timer(0.4).timeout  # tempo entre cada drop
	# Após dropar, boss fica vulnerável
	is_attacking = false
	can_walk = true
	set_state(States.Enemy.Idle)
	# Inicia o tempo de vulnerabilidade
	is_invulnerable = false # Fica vulnerável
	vulnerable_timer.start(vulnerable_time)

func drop_random_zombie() -> void:
	var scene_to_spawn: PackedScene =  zombie_man_scene if randf() < 0.5 else zombie_woman_scene
	var zombie = scene_to_spawn.instantiate() as CharacterBody2D
	zombie.global_position = drop_marker.global_position
	get_tree().current_scene.get_node("Enemies").add_child.call_deferred(zombie)

# --- Animate ---
func enemy_animate() -> void:
	if current_state == States.Enemy.Special:
		return
	var anim_name = state_names[current_state]
	anim_sprite.play(anim_name)

# --- Timer Callbacks ---
func _on_timer_timeout() -> void:
	can_walk = true

func _on_vulnerable_timer_timeout() -> void:
	if not is_invulnerable:
		is_invulnerable = true # Fica invulnerável

# --- Detect Protagonist ---
func _on_detection_area_2d_body_entered(_body: Node2D) -> void:
	if is_invulnerable and not is_attacking:
		perform_drop_zombies()

# --- Damage Protagonist ---
func _on_damage_area_2d_body_entered(body: Node2D) -> void:
	body.add_damage(damage, direction.x)

# --- Damage Enemy ---
func add_damage(damage_recieved: int, direction_recieved: int) -> void:
	super.add_damage(damage_recieved, (direction_recieved * -1))
	if not is_invulnerable:
		vulnerable_timer.stop()
		is_invulnerable = true # Fica invulnerável

# --- SFX ---
func enemy_sfx(sfx_name: String) -> void:
	super.enemy_sfx(sfx_name)
	match sfx_name:
		"drop":
			$SFX/Drop.play()
		_:
			pass
