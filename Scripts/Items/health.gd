extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	pass

func _on_area_2d_body_entered(body):
	if body.is_in_group("Protagonist"):
		body.add_health(5)
		queue_free()
