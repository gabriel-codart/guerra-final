extends Node2D

@export_multiline var text_info: String

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var level_scene: Node2D = get_tree().get_current_scene()

func _ready() -> void:
	pass

func _on_area_2d_body_entered(body):
	if body.is_in_group("Protagonist"):
		modulate = Color(0.2, 0.2, 0.2)
		anim.stop()
		level_scene.set_HUD_text(text_info)

func _on_area_2d_body_exited(body):
	if body.is_in_group("Protagonist"):
		modulate = Color(1, 1, 1)
		anim.play("idle")
		level_scene.set_HUD_text("")
