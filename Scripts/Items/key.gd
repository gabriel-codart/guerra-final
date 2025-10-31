extends CharacterBody2D

@export var key_type: Keys.Type

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var key_names = Keys.NAMES

# Constantes
const GRAVITY: float = 500

func _ready() -> void:
	sprite.play(key_names[key_type])

func _physics_process(delta: float) -> void:
	gravity(delta)
	move_and_slide()

func gravity(delta: float) -> void:
	if not is_on_floor(): # Está no ar
		velocity.y += GRAVITY * delta

func _on_area_2d_body_entered(body):
	if body.is_in_group("Protagonist"):
		body.set_key(key_type)
		queue_free()
