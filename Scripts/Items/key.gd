extends Node2D

@export var key_type: Keys.Type

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var key_names = Keys.NAMES

func _ready() -> void:
	sprite.play(key_names[key_type])

func _on_area_2d_body_entered(body):
	if body.is_in_group("Protagonist"):
		body.set_key(key_type)
		queue_free()
