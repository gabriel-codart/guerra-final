extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Constantes
const GRAVITY: float = 500

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	gravity(delta)
	move_and_slide()

func gravity(delta: float) -> void:
	if not is_on_floor(): # Está no ar
		velocity.y += GRAVITY * delta

func _on_area_2d_body_entered(body):
	if body.is_in_group("Protagonist"):
		body.add_health(1)
		queue_free()
