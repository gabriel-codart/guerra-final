extends CharacterBody2D

var projectile: PackedScene = preload("res://Scenes/Projectiles and Effects/projectile.tscn")

@onready var HUD: CanvasLayer = $"../HUD"
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon_marker: Marker2D = $WeaponMarker2D
@onready var attack_area: Area2D = $AttackArea2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
# Constantes
const GRAVITY: float = 1000
const JUMP: float = -350
const SPEED: float = 250
const SCALE: float = 1.5
# Estados
enum State { Idle, Run, Jump, Fall, Shot, Fall_Shot, Fall_Hurt, Attack, Hurt, Dead }
var state_names = {
	State.Idle: "idle",
	State.Run: "run",
	State.Jump: "jump",
	State.Fall: "fall",
	State.Shot: "shot",
	State.Fall_Shot: "fall_shot",
	State.Fall_Hurt: "fall_hurt",
	State.Attack: "attack",
	State.Hurt: "hurt",
	State.Dead: "dead",
}
var current_state: State
# Armas
enum Weapon { Default, Pistol }
var weapon_names = {
	Weapon.Default: "default",
	Weapon.Pistol: "pistol"
}
var current_weapon: Weapon
# Direção
var current_direction: Vector2
# Verificadores
var can_walk: bool
var is_attacking: bool
var is_getting_hurt: bool
# Vida
var maxHealth: int = 10
var health: int = 10

func _ready() -> void:
	current_state = State.Idle
	current_weapon = Weapon.Default
	current_direction = Vector2.RIGHT
	can_walk = true
	is_attacking = false
	is_getting_hurt = false

func _physics_process(delta: float) -> void:
	player_collision_shape(delta)
	player_gravity(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	player_get_weapon()
	player_action(delta)
	
	move_and_slide()
	player_animate()

func can_act() -> bool:
	return not is_attacking and not is_getting_hurt and current_state != State.Dead

func set_state(new_state: State) -> void:
	if current_state != new_state:
		current_state = new_state

func player_gravity(delta: float) -> void:
	if not is_on_floor(): # Está no ar
		velocity.y += GRAVITY * delta
		var protected_states = [State.Jump, State.Fall_Shot, State.Fall_Hurt, State.Dead]
		if current_state not in protected_states:
			set_state(State.Fall)

func player_idle(_delta: float) -> void:
	if is_on_floor() and can_act():
		set_state(State.Idle)

func player_run(_delta: float) -> void:
	var direction: float = Input.get_axis("move_left","move_right")
	
	if direction and can_act():
		velocity.x = direction * SPEED
		# Flipa o Personagem de acordo com a direção
		transform.x.x = direction * SCALE
		# Guarda a direção atual
		current_direction = Vector2.RIGHT if direction > 0 else Vector2.LEFT
		if is_on_floor():
			set_state(State.Run)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func player_collision_shape(_delta: float) -> void:
	match current_state:
		State.Jump:
			collision_shape.shape.height = 48
			collision_shape.position = Vector2(-1, 22)
		State.Fall, State.Fall_Shot, State.Fall_Hurt:
			collision_shape.shape.height = 60
			collision_shape.position = Vector2(-1, 28)
		_:
			collision_shape.shape.height = 62
			collision_shape.position = Vector2(-3, 32)

func player_jump(_delta: float) -> void:
	var forbidden_states = [State.Shot, State.Attack, State.Hurt, State.Fall_Hurt]
	if current_state in forbidden_states:
		return
	if Input.is_action_just_pressed("jump") and is_on_floor(): # Se remover o is_on_floor() tem-se uma mecânica de vôo
		velocity.y = JUMP
		set_state(State.Jump)

func player_get_weapon() -> void:
	if Input.is_action_just_pressed("get_default"):
		current_weapon = Weapon.Default
	if Input.is_action_just_pressed("get_pistol"):
		current_weapon = Weapon.Pistol
	
	HUD.set_weapon(current_weapon) # Atualiza arma no HUD

func player_action(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and current_weapon != Weapon.Default and can_act():
		if not is_on_floor(): # Atirando no ar
			weapon_marker.set_axis(weapon_names[current_weapon], "in_air")
			create_projectile()
			set_state(State.Fall_Shot)
			is_attacking = true
			return
		# Atirando no chão
		weapon_marker.set_axis(weapon_names[current_weapon], "on_floor")
		create_projectile()
		set_state(State.Shot)
		is_attacking = true
	if Input.is_action_just_pressed("attack") and is_on_floor() and can_act():
		set_state(State.Attack)
		is_attacking = true

func create_projectile() -> void:
	var projectile_instance: Area2D = projectile.instantiate() as Area2D
	projectile_instance.global_position = weapon_marker.global_position
	projectile_instance.direction = current_direction
	get_tree().current_scene.get_node("Projectiles").add_child(projectile_instance)

func check_attack_area() -> void:
	if attack_area.has_overlapping_bodies():
		var body: CharacterBody2D = attack_area.get_overlapping_bodies()[0] as CharacterBody2D
		if body.has_method("add_damage"):
			body.add_damage(1)

func add_damage(damage: int) -> void:
	if is_getting_hurt:
		return
	health -= damage
	HUD.set_health(health) # Atualiza barra de vida no HUD
	is_getting_hurt = true
	if health > 0:
		if not is_on_floor():
			set_state(State.Fall_Hurt)
			return
		set_state(State.Hurt)
	else:
		current_weapon = Weapon.Default
		set_state(State.Dead)

func can_play_animation() -> bool:
	if weapon_names[current_weapon] == "default" and state_names[current_state] == "shot":
		return false
	if state_names[current_state] == "dead" and not is_on_floor():
		return false
	return true

func player_animate() -> void:
	if not can_play_animation():
		return
	var anim_name = weapon_names[current_weapon] + "_" + state_names[current_state]
	anim_sprite.play(anim_name)

func _on_sprite_animation_finished():
	var anim_name: StringName = anim_sprite.animation
	if anim_name.ends_with("_jump"):
		if current_state == State.Dead:
			return
		set_state(State.Fall)
	elif anim_name.ends_with("_attack"):
		is_attacking = false
		check_attack_area()
	elif anim_name.ends_with("_shot"):
		is_attacking = false
		if anim_name.ends_with("_fall_shot"):
			set_state(State.Fall)
	elif anim_name.ends_with("_hurt"):
		is_getting_hurt = false
		is_attacking = false
		if anim_name.ends_with("_fall_hurt"):
			set_state(State.Fall)
	elif anim_name.ends_with("_dead"):
		queue_free()
