extends Node2D

@onready var HUD: CanvasLayer = $HUD

func _ready() -> void:
	HUD.set_text("Ouço prantos de horror! Seja quem for chegou no vilarejo, e não veio em paz.")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		GameManager.pause_game()

func _on_instruction_1_body_entered(body):
	if body.is_in_group("Protagonist"):
		HUD.set_text("Devo contê-los a qualquer custo! (Z para Socar)")

func _on_instruction_2_body_entered(body):
	if body.is_in_group("Protagonist"):
		HUD.set_text("Talvez seja melhor usar fogo. (2 para usar Pistola) (X para Atirar)")
