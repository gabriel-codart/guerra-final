class_name EnemyBase extends CharacterBody2D

# --- Componentes Comuns ---
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var attack_timer: Timer = get_node_or_null("AttackTimer")
@onready var detection_area: Area2D = $DetectionArea2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var attack_area: Area2D = get_node_or_null("AttackArea2D")

# --- Patrulha ---
var patrol_points: Node2D = null
var number_of_points: int
var point_positions: Array[Vector2]
var current_point: Vector2
var current_point_position: int

# --- Protagonista ---
var protagonist_point: Vector2

# --- Constantes ---
var GRAVITY: float = 1000
var SCALE: float = 1

# --- Estados ---
var current_state: int
var state_names: Dictionary = States.ENEMY_NAMES

# --- Variáveis Exportáveis ---
@export var speed: float = 1200.0
@export var damage: int = 1
@export var health: int = 2
@export var distance_to_shoot: int = 280
@export var distance_to_attack: int = 40

# --- Variáveis Comuns ---
var direction: Vector2 = Vector2.LEFT
var can_walk: bool = true
var can_attack: bool = true
var is_attacking: bool = false
var last_attack_type: String = "none" # none - melee - range

# --- Métodos Comuns ---
func _ready():
	if has_node("PatrolPoints"):
		patrol_points = $PatrolPoints
		if patrol_points != null:
			number_of_points = patrol_points.get_children().size()
			for point in patrol_points.get_children():
				point_positions.append(point.global_position)
			current_point = point_positions[current_point_position]
	
	# Conectar detection area
	if not detection_area.body_entered.is_connected(_on_detection_area_2d_body_entered):
		detection_area.body_entered.connect(_on_detection_area_2d_body_entered)
	# Conectar timers
	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	if attack_timer and not attack_timer.timeout.is_connected(_on_attack_timer_timeout):
		attack_timer.timeout.connect(_on_attack_timer_timeout)
	# Conectar animation_finished
	if not anim_sprite.animation_finished.is_connected(_on_animated_sprite_finished):
		anim_sprite.animation_finished.connect(_on_animated_sprite_finished)

func _physics_process(delta):
	check_detection_area()
	enemy_gravity(delta)
	if is_on_floor():
		enemy_idle(delta)
		enemy_walk(delta)
	else:
		# Garante que não haja interferência enquanto está no ar
		velocity.x = move_toward(velocity.x, 0, speed * delta)
	move_and_slide()
	enemy_animate()

func can_act() -> bool:
	return not is_attacking and can_walk and current_state != States.Enemy.Dead and current_state != States.Enemy.Hurt

func set_state(new_state: States.Enemy) -> void:
	if current_state != new_state:
		current_state = new_state
		if new_state != States.Enemy.Attack and new_state != States.Enemy.Shot:
			is_attacking = false

func enemy_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		var protected_states = [States.Enemy.Fall, States.Enemy.Dead, States.Enemy.Hurt]
		if current_state not in protected_states:
			is_attacking = false
			set_state(States.Enemy.Fall)
	else:
		# Quando pousar no chão
		if current_state == States.Enemy.Fall:
			set_state(States.Enemy.Idle)

func enemy_idle(delta: float) -> void:
	if is_attacking or current_state == States.Enemy.Dead:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		return
	if not can_walk:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		set_state(States.Enemy.Idle)

func enemy_walk(delta: float) -> void:
	if not can_act():
		return
	
	if protagonist_point != Vector2.ZERO:
		go_to_protagonist(delta)
	elif number_of_points > 0:
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

func enemy_attack() -> void:
	set_state(States.Enemy.Attack)
	is_attacking = true
	last_attack_type = "melee"

func check_attack_area() -> void:
	if attack_area.has_overlapping_bodies():
		for body in attack_area.get_overlapping_bodies():
			if body.is_in_group("Protagonist") and body.has_method("add_damage"):
				body.add_damage(damage, direction.x)

func add_damage(damage_recieved: int, direction_recieved: int) -> void:
	if current_state == States.Enemy.Attack:
		return
	if current_state == States.Enemy.Dead or current_state == States.Enemy.Hurt:
		return
	
	health -= damage_recieved
	anim_player.play("hurt")
	enemy_sfx("hurt")
	velocity = Vector2(direction_recieved * 45, 0)
	# Flipa o Personagem de acordo com a direção
	transform.x.x = (direction_recieved * -1) * SCALE
	
	if health <= 0:
		set_state(States.Enemy.Dead)
		enemy_sfx("dead")
	else:
		set_state(States.Enemy.Hurt)

func enemy_animate() -> void:
	if current_state == States.Enemy.Special:
		return
	if current_state == States.Enemy.Hurt and not is_on_floor():
		return
	if current_state == States.Enemy.Dead and not is_on_floor():
		return
	var anim_name = state_names[current_state]
	anim_sprite.play(anim_name)

func enemy_sfx(sfx_name: String) -> void:
	match sfx_name:
		"walk":
			$SFX/Walk.play()
		"hurt":
			$SFX/Hurt.play()
		"dead":
			$SFX/Dead.play()
		_:
			pass

func enemy_dead() -> void:
	queue_free()

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
