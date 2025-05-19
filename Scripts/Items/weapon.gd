extends Node2D

@export var weapon_type: Weapons.Type

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon_names = Weapons.NAMES

func _ready() -> void:
	sprite.play(weapon_names[weapon_type])

func _on_area_2d_body_entered(body):
	if body.is_in_group("Protagonist"):
		body.set_weapon(weapon_type)
		queue_free()
