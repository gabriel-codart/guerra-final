extends EnemyBoss

# Marcadoras de Posição
@onready var weapon_marker_1: Marker2D = $WeaponMarkers/WeaponMarker1
@onready var weapon_marker_2: Marker2D = $WeaponMarkers/WeaponMarker2
@onready var sfx: Node = $SFX
# Variáveis de patrulha
var current_point_index: int = 0
# Controle geral
var searching_prota: bool = true
# Drop de inimigos
@export var times_to_shot: int = 3
# Damage Area
@onready var damage_area: Area2D = $DamageArea2D
# Configuração de vulnerabilidade
@onready var vulnerable_timer: Timer = $VulnerableTimer
@export var vulnerable_time: float = 30.0
# Direção Vertical
var vertical_direction: Vector2 = Vector2.UP

func _ready() -> void:
	super._ready()
	# Conectar damage area
	if not damage_area.body_entered.is_connected(_on_damage_area_2d_body_entered):
		damage_area.body_entered.connect(_on_damage_area_2d_body_entered)
	# Conectar vulnerable timer
	if not vulnerable_timer.timeout.is_connected(_on_vulnerable_timer_timeout):
		vulnerable_timer.timeout.connect(_on_vulnerable_timer_timeout)

func _physics_process(delta: float) -> void:
	enemy_gravity(delta)
	enemy_idle(delta)
	enemy_walk(delta)
	move_and_slide()
	enemy_animate()
	#print(state_names[current_state])

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
	check_vertical_direction(current_point)
	if abs(position.y - current_point.y) > 0.5:
		velocity.y = vertical_direction.y * speed * delta
		set_state(States.Enemy.Walk)
	else:
		current_point_position = (current_point_position + 1) % number_of_points
		current_point = point_positions[current_point_position]
		check_vertical_direction(current_point)
		can_walk = false
		timer.start(1.0)

func check_vertical_direction(target_point: Vector2) -> void:
	vertical_direction = Vector2.UP if target_point.y < global_position.y else Vector2.DOWN

# --- Attacking ---
func enemy_shoot() -> void:
	if is_attacking or not can_act():
		return
	set_state(States.Enemy.Special)
	is_attacking = true
	can_walk = false
	# Inicia o processo de drop com coroutine
	await get_tree().create_timer(1.0).timeout  # pequena pausa antes de começar a soltar
	var total_shots = times_to_shot * phase
	for i in range(total_shots):
		create_projectile(weapon_marker_1.global_position)
		create_projectile(weapon_marker_2.global_position)
		await get_tree().create_timer(0.4).timeout  # tempo entre cada shot
	# Após dropar, boss fica vulnerável
	is_attacking = false
	can_walk = true
	set_state(States.Enemy.Idle)
	# Inicia o tempo de vulnerabilidade
	is_invulnerable = false # Fica vulnerável
	vulnerable_timer.start(vulnerable_time)

func create_projectile(marker_position: Vector2) -> void:
	var projectile_instance: Node2D = projectile.instantiate() as Node2D
	projectile_instance.global_position = marker_position
	projectile_instance.direction = direction
	projectile_instance.damage = damage
	projectile_instance.target_group = "Protagonist"
	get_tree().current_scene.get_node("Projectiles").add_child.call_deferred(projectile_instance)

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
		enemy_shoot()

# --- Damage Protagonist ---
func _on_damage_area_2d_body_entered(body: Node2D) -> void:
	body.add_damage(damage, direction.x)

# --- Damage Enemy ---
func add_damage(damage_recieved: int, direction_recieved: int) -> void:
	super.add_damage(damage_recieved, (direction_recieved))
	velocity = Vector2.ZERO
	if not is_invulnerable:
		vulnerable_timer.stop()
		is_invulnerable = true # Fica invulnerável
	#print(state_names[current_state])
