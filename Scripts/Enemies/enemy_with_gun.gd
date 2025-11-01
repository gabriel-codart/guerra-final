class_name EnemyWithGun extends EnemyBase

@onready var weapon_marker: Marker2D = get_node_or_null("WeaponMarker2D")
var projectile: PackedScene = preload("res://Scenes/Projectiles and Effects/projectile.tscn")

func _ready():
	state_names = States.ENEMY_NAMES
	set_state(States.Enemy.Idle)
	super._ready()

func go_to_protagonist(delta: float) -> void:
	check_direction(protagonist_point)
	var current_distance = abs(position.x - protagonist_point.x)
	# Se o inimigo estiver longe, caminha até o protagonista
	if current_distance > distance_to_shoot:
		velocity.x = direction.x * speed * delta
		set_state(States.Enemy.Walk)
		return
	# Verifica se está no chão
	if not is_on_floor():
		return
	# Verifica se está no cooldown
	if not can_attack:
		# Situação especial:
		# O inimigo atirou há pouco tempo, mas agora o protagonista está colado
		if current_distance <= distance_to_attack and last_attack_type == "ranged" and current_state == States.Enemy.Idle:
			# Força o reset do cooldown
			attack_timer.stop()
			can_attack = true
			enemy_attack()
			return
		# Caso normal: mantém Idle e espera cooldown
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		set_state(States.Enemy.Idle)
		return
	# Pode atacar normalmente
	if current_distance <= distance_to_attack:
		# Ataque Corpo a Corpo
		enemy_attack()
	else:
		# Ataque a Distância
		enemy_shoot()

func enemy_shoot() -> void:
	create_projectile(weapon_marker.global_position)
	set_state(States.Enemy.Shot)
	is_attacking = true
	last_attack_type = "ranged"

func create_projectile(marker_position: Vector2) -> void:
	var projectile_instance: Node2D = projectile.instantiate() as Node2D
	projectile_instance.global_position = marker_position
	projectile_instance.direction = direction
	projectile_instance.damage = damage
	projectile_instance.target_group = "Protagonist"
	get_tree().current_scene.get_node("Projectiles").add_child.call_deferred(projectile_instance)

func _on_animated_sprite_finished() -> void:
	var anim_name: StringName = anim_sprite.animation
	if anim_name == "attack":
		is_attacking = false
		can_attack = false
		check_attack_area()
		attack_timer.start(0.5)
	elif anim_name == "shot":
		is_attacking = false
		can_attack = false
		attack_timer.start(1.5)
	elif anim_name == "hurt":
		if current_state == States.Enemy.Hurt:
			set_state(States.Enemy.Idle)
	elif anim_name == "dead":
		queue_free()
