class_name EnemyWithoutGun extends EnemyBase

func _ready():
	state_names = States.ENEMY_NAMES
	set_state(States.Enemy.Idle)
	super._ready()

func go_to_protagonist(delta: float) -> void:
	check_direction(protagonist_point)
	var current_distance = abs(position.x - protagonist_point.x)
	
	if current_distance > distance_to_attack:
		velocity.x = direction.x * speed * delta
		set_state(States.Enemy.Walk)
	else:
		# Verifica se está no chão
		if not is_on_floor():
			return
		if not can_attack:
			velocity.x = move_toward(velocity.x, 0, speed * delta)
			set_state(States.Enemy.Idle)
			return
		enemy_attack()

func _on_animated_sprite_finished() -> void:
	var anim_name: StringName = anim_sprite.animation
	if anim_name == "walk":
		enemy_sfx("walk")
	elif anim_name == "attack":
		is_attacking = false
		can_attack = false
		check_attack_area()
		attack_timer.start(0.1)
	elif anim_name == "hurt":
		if current_state == States.Enemy.Hurt:
			set_state(States.Enemy.Idle)
	elif anim_name == "dead":
		enemy_dead()
