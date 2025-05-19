class_name EnemyBase extends CharacterBody2D

# --- Componentes Comuns ---
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var attack_timer: Timer = $AttackTimer
@onready var detection_area: Area2D = $DetectionArea2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# --- Patrulha ---
@onready var patrol_points: Node2D = $PatrolPoints
var number_of_points: int
var point_positions: Array[Vector2]
var current_point: Vector2
var current_point_position: int

# --- Protagonista ---
var protagonist_point: Vector2

# --- Constantes ---
const GRAVITY: float = 1000
const SCALE: float = 1

# --- Estados ---
var current_state: int
var state_names: Dictionary = States.ENEMY_NAMES

# --- Variáveis Exportáveis
@export var speed: float = 1200.0
@export var damage: int = 1
@export var health: int = 5
# --- Variáveis Comuns ---
var direction: Vector2 = Vector2.LEFT
var can_walk: bool = true
var can_attack: bool = true
var is_attacking: bool = false

# --- Métodos Comuns ---
func _ready():
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else:
		print('No patrol points')
	
	# Conectar detection area
	if not detection_area.body_entered.is_connected(_on_detection_area_2d_body_entered):
		detection_area.body_entered.connect(_on_detection_area_2d_body_entered)
	# Conectar timers se não estiverem conectados
	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	if not attack_timer.timeout.is_connected(_on_attack_timer_timeout):
		attack_timer.timeout.connect(_on_attack_timer_timeout)
	# Conectar animation_finished do AnimatedSprite2D
	if not anim_sprite.animation_finished.is_connected(_on_animated_sprite_finished):
		anim_sprite.animation_finished.connect(_on_animated_sprite_finished)

func _physics_process(delta):
	check_detection_area()
	enemy_gravity(delta)
	enemy_idle(delta)
	enemy_walk(delta)
	move_and_slide()
	enemy_animate()

func enemy_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

func can_act() -> bool:
	return not is_attacking and can_walk and current_state != States.Enemy.Dead

func enemy_idle(delta: float) -> void:
	if is_attacking:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		return
	if not can_walk:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		current_state = States.Enemy.Idle

func enemy_walk(delta: float) -> void:
	if not can_act():
		return

	if protagonist_point != Vector2.ZERO:
		go_to_protagonist(delta)
	elif number_of_points != 0:
		go_to_patrol(delta)

	if can_walk:
		transform.x.x = direction.x * SCALE

func go_to_patrol(delta: float) -> void:
	check_direction(current_point)
	if abs(position.x - current_point.x) > 0.5:
		velocity.x = direction.x * speed * delta
		current_state = States.Enemy.Walk
	else:
		current_point_position = (current_point_position + 1) % number_of_points
		current_point = point_positions[current_point_position]
		check_direction(current_point)
		can_walk = false
		timer.start()

func go_to_protagonist(_delta: float) -> void:
	push_error("go_to_protagonist() not implemented in EnemyBase. This should be implemented in the child class.")

func check_direction(target_point: Vector2) -> void:
	direction = Vector2.RIGHT if target_point.x > global_position.x else Vector2.LEFT

func check_detection_area() -> void:
	if detection_area.has_overlapping_bodies():
		protagonist_point = detection_area.get_overlapping_bodies()[0].global_position
	else:
		protagonist_point = Vector2.ZERO

func add_damage(damage_recieved: int) -> void:
	health -= damage_recieved
	anim_player.play("hurt")
	if health <= 0:
		current_state = States.Enemy.Dead
		velocity = Vector2.ZERO

func enemy_animate() -> void:
	var anim_name = state_names.get(current_state, "idle")
	anim_sprite.play(anim_name)

# --- Detect Protagonist ---
func _on_detection_area_2d_body_entered(body: Node2D) -> void:
	protagonist_point = body.global_position

# --- Timer Callbacks ---
func _on_timer_timeout() -> void:
	can_walk = true

func _on_attack_timer_timeout() -> void:
	can_attack = true

# --- Animated Sprite 2D Callback ---
func _on_animated_sprite_finished() -> void:
	push_error("_on_animated_sprite_finished() not implemented in EnemyBase. This should be implemented in the child class.")
