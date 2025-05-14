extends Area2D

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
	pass

func _process(delta: float) -> void:
	translate(direction * SPEED * delta)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(target_group) and body.has_method("add_damage"):
		body.add_damage(damage)
		create_projectile_impact()

func _on_area_entered(_area: Area2D) -> void:
	create_projectile_impact()

func create_projectile_impact() -> void:
	var projectile_impact_instance: AnimatedSprite2D = projectile_impact.instantiate() as AnimatedSprite2D
	projectile_impact_instance.global_position = global_position
	get_parent().add_child(projectile_impact_instance)
	queue_free()
