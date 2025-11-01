class_name EnemyBoss extends EnemyWithGun

@onready var HUD: CanvasLayer = $"../HUD"
@export var boss_name: StringName = "BOSS"
@export var maxHealth: int = 10
var phase: int = 1
var shots_before_special: int = 3
var current_shots: int = 0
var is_invulnerable: bool = true

func can_act() -> bool:
	return super.can_act() and current_state != States.Enemy.Special

func add_damage(damage_recieved: int, direction_recieved: int) -> void:
	if is_invulnerable:
		anim_player.play("intangible")
		return
	super.add_damage(damage_recieved, direction_recieved)
	phase += 1
	HUD.set_boss_health(health) # Atualiza barra de vida no HUD

func reset_shots():
	current_shots = 0
