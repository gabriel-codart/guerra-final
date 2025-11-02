extends EnemyBoss

@onready var hook_line: ColorRect = $HookLine

@export var hook_rise_speed: float = 200.0
@export var hook_wait_time: float = 2.0
@export var hook_height: float = 400.0 # quanto sobe
@export var hook_swap_sides: bool = true

var hook_active: bool = false
var hook_direction: int = 1 # 1 = direita, -1 = esquerda

func _ready():
	super._ready()
	hook_line.visible = false

func enemy_gravity(delta: float) -> void:
	# Se o hook está ativo, ignora a gravidade e mantém o estado/posição
	if hook_active:
		velocity.y = 0
		return
	# Caso contrário, comportamento padrão
	super.enemy_gravity(delta)

func enemy_shoot() -> void:
	super.enemy_shoot()
	current_shots += 1
	if current_shots >= shots_before_special:
		current_shots = 0
		enemy_hook()

func enemy_hook() -> void:
	if hook_active:
		return
	hook_active = true
	is_invulnerable = false
	set_state(States.Enemy.Special)
	anim_sprite.play("hook")
	enemy_sfx("hook")

func _on_animated_sprite_finished():
	var anim_name = anim_sprite.animation
	if anim_name == "hook":
		# inicia movimento para cima
		move_up_and_relocate()
	elif anim_name == "dead":
		queue_free()
	else:
		super._on_animated_sprite_finished()

func move_up_and_relocate() -> void:
	hook_line.visible = true
	var tween = get_tree().create_tween()
	var target_y = global_position.y - hook_height
	tween.tween_property(self, "position:y", target_y, 1.5)
	tween.tween_callback(Callable(self, "_on_hook_exit"))

func _on_hook_exit():
	check_direction(current_point)
	if hook_swap_sides:
		# alterna de lado
		hook_direction *= -1
		global_position.x += 450 * hook_direction
	# desce de volta
	var tween = get_tree().create_tween()
	var target_y = global_position.y + hook_height
	tween.tween_property(self, "position:y", target_y, 1.5)
	tween.tween_callback(Callable(self, "_on_hook_return"))

func _on_hook_return():
	hook_line.visible = false
	# Roda a animação Hook Reverse
	anim_sprite.play("hook_reverse")
	await anim_sprite.animation_finished
	# Volta ao normal
	hook_active = false
	is_invulnerable = true
	set_state(States.Enemy.Idle)

# --- SFX ---
func enemy_sfx(sfx_name: String) -> void:
	super.enemy_sfx(sfx_name)
	match sfx_name:
		"hook":
			$SFX/Hook.play()
		"hook_inverse":
			$SFX/HookDown.play()
		_:
			pass
