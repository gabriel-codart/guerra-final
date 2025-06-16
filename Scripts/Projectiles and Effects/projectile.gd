extends Node2D

# Impacto
var projectile_impact: PackedScene = preload("res://Scenes/Projectiles and Effects/projectile_impact.tscn")
# Constantes
const SPEED: float = 400.0
# Direção
var direction: Vector2
# Dano
var damage: int = 1
# Alvo
var target_group: String

func _ready() -> void:
	player_sfx("shoot")
	transform.x.x = 1 if direction == Vector2.RIGHT else -1

func _process(delta: float) -> void:
	translate(direction * SPEED * delta)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(object: Node2D) -> void:
	if object is TileMapLayer:
		create_projectile_impact()
		return
	
	if object.is_in_group(target_group) and object.has_method("add_damage"):
		object.add_damage(damage)
		create_projectile_impact()

func create_projectile_impact() -> void:
	var projectile_impact_instance: AnimatedSprite2D = projectile_impact.instantiate() as AnimatedSprite2D
	projectile_impact_instance.global_position = global_position
	get_parent().add_child(projectile_impact_instance)
	player_sfx("impact")
	queue_free()

func player_sfx(sfx_name: String) -> void:
	match sfx_name:
		"shoot":
			$SFX/Shoot.play()
		"impact":
			$SFX/Impact.play()
		_:
			pass
