extends Node2D

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _on_animated_sprite_finished() -> void:
	var anim_name: StringName = anim_sprite.animation
	if anim_name == "default":
		queue_free()
