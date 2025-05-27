extends CharacterBody2D

class_name Protagonist

var projectile: PackedScene = preload("res://Scenes/Projectiles and Effects/projectile.tscn")

@onready var HUD: CanvasLayer = $"../HUD"
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var weapon_marker: Marker2D = $WeaponMarker2D
@onready var attack_area: Area2D = $AttackArea2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
# Constantes
const GRAVITY: float = 1000
const JUMP: float = -300
const SPEED: float = 200
const SCALE: float = 1
# Estados
@onready var states = States.Protagonist
@onready var state_names = States.PROTAGONIST_NAMES
var current_state: States.Protagonist
# Armas
@onready var weapon_names = Weapons.NAMES
var current_weapon: Weapons.Type
# Chaves
var current_key: Keys.Type
# Direção
var current_direction: Vector2
# Verificadores
var can_walk: bool
var is_attacking: bool
# Vida
var maxHealth: int = 10
var health: int

func _ready() -> void:
	health = PlayerManager.health
	current_weapon = PlayerManager.current_weapon
	current_key = PlayerManager.current_key
	current_state = States.Protagonist.Idle
	current_direction = Vector2.RIGHT
	can_walk = true
	is_attacking = false

func _physics_process(delta: float) -> void:
	player_gravity(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	player_action(delta)
	player_pause(delta)
	
	move_and_slide()
	player_animate()

func can_act() -> bool:
	return not is_attacking and current_state != States.Protagonist.Dead

func set_state(new_state: States.Protagonist) -> void:
	if current_state != new_state:
		current_state = new_state
		player_collision_shape()

func set_weapon(new_weapon: Weapons.Type) -> void:
	current_weapon = new_weapon
	HUD.set_weapon(new_weapon)

func set_key(new_key: Keys.Type) -> void:
	current_key = new_key
	HUD.set_key(new_key)

func player_gravity(delta: float) -> void:
	if not is_on_floor(): # Está no ar
		velocity.y += GRAVITY * delta
		var protected_states = [States.Protagonist.Jump, States.Protagonist.Fall_Shot, States.Protagonist.Dead]
		if current_state not in protected_states:
			set_state(States.Protagonist.Fall)

func player_idle(_delta: float) -> void:
	if is_on_floor() and can_act():
		set_state(States.Protagonist.Idle)

func player_run(_delta: float) -> void:
	var direction: float = Input.get_axis("move_left","move_right")
	
	if direction and can_act():
		velocity.x = direction * SPEED
		# Flipa o Personagem de acordo com a direção
		transform.x.x = direction * SCALE
		# Guarda a direção atual
		current_direction = Vector2.RIGHT if direction > 0 else Vector2.LEFT
		if is_on_floor():
			set_state(States.Protagonist.Run)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func player_collision_shape() -> void:
	match current_state:
		States.Protagonist.Dead:
			collision_shape.shape.radius = 8.5
			collision_shape.shape.height = 17
			collision_shape.position = Vector2(-14, 56)
		States.Protagonist.Jump:
			collision_shape.shape.radius = 10
			collision_shape.shape.height = 48
			collision_shape.position = Vector2(-1, 22)
		_:
			collision_shape.shape.radius = 10
			collision_shape.shape.height = 62
			collision_shape.position = Vector2(-3, 32)

func player_jump(_delta: float) -> void:
	var forbidden_states = [States.Protagonist.Shot, States.Protagonist.Attack, States.Protagonist.Dead]
	if current_state in forbidden_states:
		return
	if Input.is_action_just_pressed("jump") and is_on_floor(): # Se remover o is_on_floor() tem-se uma mecânica de vôo
		velocity.y = JUMP
		set_state(States.Protagonist.Jump)

func player_action(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and current_weapon != Weapons.Type.Default and can_act():
		if not is_on_floor(): # Atirando no ar
			# Shotgun e Rassault não podem atirar no ar
			if current_weapon == Weapons.Type.Shotgun or current_weapon == Weapons.Type.Rassault:
				return
			
			# Outras armas atiram no ar normalmente
			weapon_marker.set_axis(weapon_names[current_weapon], "in_air")
			create_projectile()
			set_state(States.Protagonist.Fall_Shot)
			is_attacking = true
			return
		# Atirando no chão
		weapon_marker.set_axis(weapon_names[current_weapon], "on_floor")
		create_projectile()
		set_state(States.Protagonist.Shot)
		is_attacking = true
	if Input.is_action_just_pressed("attack") and is_on_floor() and can_act():
		set_state(States.Protagonist.Attack)
		is_attacking = true

func create_projectile() -> void:
	var projectile_instance: Area2D = projectile.instantiate() as Area2D
	projectile_instance.global_position = weapon_marker.global_position
	projectile_instance.direction = current_direction
	projectile_instance.target_group = "Enemy"
	projectile_instance.damage = current_weapon
	get_tree().current_scene.get_node("Projectiles").add_child(projectile_instance)

func check_attack_area() -> void:
	if attack_area.has_overlapping_bodies():
		var body: CharacterBody2D = attack_area.get_overlapping_bodies()[0] as CharacterBody2D
		if body.is_in_group("Enemy") and body.has_method("add_damage"):
			body.add_damage(1)

func player_pause(_delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		GameManager.go_to_pause_menu()

func add_health(health_recieved: int) -> void:
	if maxHealth <= health + health_recieved:
		health = maxHealth
	else:
		health += health_recieved
	HUD.set_health(health)

func add_damage(damage_recieved: int) -> void:
	health -= damage_recieved
	HUD.set_health(health) # Atualiza barra de vida no HUD
	anim_player.play("hurt")
	if health <= 0:
		current_weapon = Weapons.Type.Default
		set_state(States.Protagonist.Dead)

func can_play_animation() -> bool:
	if current_weapon == Weapons.Type.Default and current_state == States.Protagonist.Shot:
		return false
	if current_state == States.Protagonist.Dead and not is_on_floor():
		return false
	return true

func player_animate() -> void:
	if not can_play_animation():
		return
	var anim_name: String
	if current_state == States.Protagonist.Run and current_weapon != Weapons.Type.Default:
		anim_name = "weapon_run"
	else:
		anim_name = weapon_names[current_weapon] + "_" + state_names[current_state]
	anim_sprite.play(anim_name)

func _on_sprite_animation_finished():
	var anim_name: StringName = anim_sprite.animation
	if anim_name.ends_with("_jump"):
		if current_state == States.Protagonist.Dead:
			return
		set_state(States.Protagonist.Fall)
	elif anim_name.ends_with("_attack"):
		is_attacking = false
		check_attack_area()
	elif anim_name.ends_with("_shot"):
		is_attacking = false
		if anim_name.ends_with("_fall_shot"):
			set_state(States.Protagonist.Fall)
	elif anim_name.ends_with("_dead"):
		get_tree().paused = true
		GameManager.go_to_game_over()
