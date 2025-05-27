extends EnemyBase

@onready var attack_area: Area2D = $AttackArea2D

func _ready():
	state_names = States.ENEMY_NAMES
	set_state(States.Enemy.Idle)
	
	super._ready()

func go_to_protagonist(delta: float) -> void:
	check_direction(protagonist_point)
	if abs(position.x - protagonist_point.x) > distance_to_attack:
		velocity.x = direction.x * speed * delta
		set_state(States.Enemy.Walk)
	else:
		if not can_attack:
			velocity.x = move_toward(velocity.x, 0, speed * delta)
			set_state(States.Enemy.Idle)
			return
		enemy_attack()

func enemy_attack() -> void:
	set_state(States.Enemy.Attack)
	is_attacking = true

func check_attack_area() -> void:
	if attack_area.has_overlapping_bodies():
		for body in attack_area.get_overlapping_bodies():
			if body.is_in_group("Protagonist") and body.has_method("add_damage"):
				body.add_damage(damage)

func _on_animated_sprite_finished() -> void:
	var anim_name: StringName = anim_sprite.animation
	if anim_name == "attack":
		is_attacking = false
		can_attack = false
		check_attack_area()
		attack_timer.start()
	elif anim_name == "dead":
		queue_free()
