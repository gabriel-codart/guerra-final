extends CharacterBody2D

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite

const SPEED: float = 150.0
const JUMP_VELOCITY: float = -300.0
var is_attacking: bool = false
var is_jumping: bool = false
var is_falling: bool = false

func _physics_process(delta):
	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	action_handler()
	if not is_attacking:
		move()
		animate()

func move() -> void:
	# Movimentação Horizontal
	var input_direction: float = Input.get_axis("left", "right")
	if input_direction:
		velocity.x = input_direction * SPEED
		transform.x.x = input_direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func animate() -> void:
	# Animações
	if is_on_floor() and not is_jumping:
		if velocity == Vector2.ZERO:
			anim_sprite.play("idle")
		else:
			anim_sprite.play("run")
	elif not is_on_floor() and not is_jumping:
		anim_sprite.play("fall")

func action_handler() -> void:
	# Ações
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim_sprite.play("jump")
		is_jumping = true
		return
	if Input.is_action_just_pressed("shoot") and is_on_floor():
		anim_sprite.play("shotgun")
		is_attacking = true
		return
	if Input.is_action_just_pressed("attack") and is_on_floor():
		anim_sprite.play("attack")
		is_attacking = true
		return

func _on_sprite_animation_finished():
	match anim_sprite.animation:
		"shotgun","attack":
			is_attacking = false
		"jump":
			is_jumping = false
