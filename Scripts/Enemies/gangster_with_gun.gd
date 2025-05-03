extends CharacterBody2D

var projectile: PackedScene = preload("res://Scenes/Projectiles and Effects/projectile.tscn")

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var attack_timer: Timer = $AttackTimer
@onready var weapon_marker: Marker2D = $WeaponMarker2D
@onready var detection_area: Area2D = $DetectionArea2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
# Pontos de Patrulha
@export var patrol_points: Node2D
var number_of_points: int
var point_positions: Array[Vector2]
var current_point: Vector2
var current_point_position: int
# Ponto do Protagonista
var protagonist_point: Vector2
# Constantes
const SPEED: float = 1500.0
const GRAVITY: float = 1000
const SCALE: float = 1.45
# Estados
enum State { Idle, Walk, Shot, Hurt, Dead }
var state_names = {
	State.Idle: "idle",
	State.Walk: "walk",
	State.Shot: "shot",
	State.Dead: "dead",
	State.Hurt: "hurt",
}
var current_state: State
# Direção
var direction: Vector2 = Vector2.LEFT
# Verificadores
var can_walk: bool
var can_attack: bool
var is_shooting: bool
var is_getting_hurt: bool
var health: int = 5

func _ready():
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else:
		print('No patrol points')
	current_state = State.Idle
	can_walk = true
	can_attack = true
	is_shooting = false
	is_getting_hurt = false

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
	return not is_shooting and not is_getting_hurt and can_walk and current_state != State.Dead

func enemy_idle(delta: float) -> void:
	if is_shooting or is_getting_hurt:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		return
	if not can_walk:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		current_state = State.Idle

func enemy_walk(delta: float) -> void:
	if not can_act():
		return
	
	if protagonist_point != Vector2.ZERO:
		go_to_protagonist(delta)
	elif number_of_points != 0:
		go_to_patrol(delta)
	
	if can_walk:
		# Flipa o Personagem de acordo com a direção
		transform.x.x = direction.x * SCALE

func go_to_protagonist(delta: float) -> void:
	check_direction(protagonist_point)
	# Checa a distância do Protagonista
	if abs(position.x - protagonist_point.x) > 220:
		velocity.x = direction.x * SPEED * delta
		current_state = State.Walk
	else:
		if not can_attack:
			velocity.x = move_toward(velocity.x, 0, SPEED * delta)
			current_state = State.Idle
			return
		enemy_shoot()

func go_to_patrol(delta: float) -> void:
	check_direction(current_point)
	if abs(position.x - current_point.x) > 0.5:
		velocity.x = direction.x * SPEED * delta
		current_state = State.Walk
	else:
		current_point_position += 1
		
		if current_point_position >= number_of_points:
			current_point_position = 0
		
		current_point = point_positions[current_point_position]
		check_direction(current_point)
		
		can_walk = false
		timer.start()

func check_direction(target_point: Vector2) -> void:
	if target_point.x > global_position.x:
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT

func check_detection_area() -> void:
	if detection_area.has_overlapping_bodies():
		protagonist_point = detection_area.get_overlapping_bodies()[0].global_position
	else:
		protagonist_point = Vector2.ZERO

func enemy_shoot() -> void:
	create_projectile()
	current_state = State.Shot
	is_shooting = true

func create_projectile() -> void:
	var projectile_instance: Area2D = projectile.instantiate() as Area2D
	projectile_instance.global_position = weapon_marker.global_position
	projectile_instance.direction = direction
	projectile_instance.damage = 2
	get_tree().current_scene.get_node("Projectiles").add_child(projectile_instance)

func add_damage(damage: int) -> void:
	if is_getting_hurt:
		return
	health -= damage
	is_getting_hurt = true
	if health > 0:
		current_state = State.Hurt
	else:
		current_state = State.Dead
		collision_shape.disabled = true
	print("Health: ", health, " + State: ", state_names[current_state])

func enemy_animate() -> void:
	var anim_name = state_names[current_state]
	anim_sprite.play(anim_name)

func _on_timer_timeout() -> void:
	can_walk = true

func _on_attack_timer_timeout():
	can_attack = true

func _on_animated_sprite_finished() -> void:
	var anim_name: StringName = anim_sprite.animation
	if anim_name == "shot":
		is_shooting = false
		can_attack = false
		attack_timer.start()
	elif anim_name == "hurt":
		is_getting_hurt = false
		is_shooting = false
		can_attack = true
	elif anim_name == "dead":
		queue_free()

func _on_detection_area_2d_body_entered(body: Node2D) -> void:
	protagonist_point = body.global_position
