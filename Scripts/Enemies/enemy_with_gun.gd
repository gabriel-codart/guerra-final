extends EnemyBase

@onready var weapon_marker: Marker2D = $WeaponMarker2D
var projectile: PackedScene = preload("res://Scenes/Projectiles and Effects/projectile.tscn")

func _ready():
	state_names = States.ENEMY_NAMES
	set_state(States.Enemy.Idle)
	
	super._ready()

func go_to_protagonist(delta: float) -> void:
	check_direction(protagonist_point)
	if abs(position.x - protagonist_point.x) > distance_to_shoot:
		velocity.x = direction.x * speed * delta
		set_state(States.Enemy.Walk)
	else:
		if not can_attack:
			velocity.x = move_toward(velocity.x, 0, speed * delta)
			set_state(States.Enemy.Idle)
			return
		enemy_shoot()

func enemy_shoot() -> void:
	create_projectile()
	set_state(States.Enemy.Shot)
	is_attacking = true

func create_projectile() -> void:
	var projectile_instance: Node2D = projectile.instantiate() as Node2D
	projectile_instance.global_position = weapon_marker.global_position
	projectile_instance.direction = direction
	projectile_instance.damage = damage
	projectile_instance.target_group = "Protagonist"
	get_tree().current_scene.get_node("Projectiles").add_child(projectile_instance)

func _on_animated_sprite_finished() -> void:
	var anim_name: StringName = anim_sprite.animation
	if anim_name == "shot":
		is_attacking = false
		can_attack = false
		attack_timer.start()
	elif anim_name == "hurt":
		if current_state == States.Enemy.Hurt:
			set_state(States.Enemy.Idle)
	elif anim_name == "dead":
		queue_free()
