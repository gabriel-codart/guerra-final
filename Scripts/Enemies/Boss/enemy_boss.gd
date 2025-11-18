extends EnemyWithGun
class_name EnemyBoss

signal dead

@onready var HUD: CanvasLayer = $"../HUD"
@export var boss_name: StringName = "BOSS"
var phase: int = 1
var shots_before_special: int = 3
var current_shots: int = 0
var is_invulnerable: bool = true
var is_dead: bool = false

func _physics_process(delta):
	if is_dead:
		return
	super._physics_process(delta)

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

func enemy_dead() -> void:
	dead.emit()

func _on_animated_sprite_finished():
	var anim_name = anim_sprite.animation
	if anim_name == "dead":
		is_dead = true
		enemy_dead()
	else:
		super._on_animated_sprite_finished()

# --- Detect Protagonist ---
func _on_detection_area_2d_body_entered(body: Node2D) -> void:
	protagonist_point = body.global_position

func _on_detection_area_2d_body_exited(_body: Node2D) -> void:
	pass
