extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var blur_rect = $BlurRect
@onready var mat: ShaderMaterial = blur_rect.material

var _is_transitioning := false

func _ready() -> void:
	blur_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	blur_rect.color = Color(0, 0, 0, 0)
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	color_rect.color = Color(0, 0, 0, 0)
	set_process_input(false)

func _input(_event):
	# Bloqueia todos os inputs enquanto estiver em transição
	if _is_transitioning:
		get_viewport().set_input_as_handled()

func play_transition(target_scene: PackedScene) -> void:
	# 0. Verifica se está em Transição e depois bloqueia os inputs
	if _is_transitioning:
		return # evita chamadas duplas
	_is_transitioning = true
	set_process_input(true)
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	blur_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	# Cria tween para animar o blur
	var tween = create_tween()
	# 1. Aplica blur (0 → 2.5 em 1s) + fade in (alpha 0 → 1 em 1s)
	tween.tween_property(mat, "shader_parameter/blur_size", 2.5, 1.0)
	tween.parallel().tween_property(color_rect, "color:a", 1.0, 1.0)
	# 2. Troca a cena quando estiver escuro e borrado
	tween.tween_callback(func():
		get_tree().change_scene_to_packed(target_scene)
	)
	# 3. Remove o blur (2.5 → 0 em 1s) + fade out (alpha 1 → 0 em 1s)
	tween.tween_property(mat, "shader_parameter/blur_size", 0.0, 1.0)
	tween.parallel().tween_property(color_rect, "color:a", 0.0, 1.0)
	# 4. Libera os inputs ao final
	tween.tween_callback(func():
		_is_transitioning = false
		set_process_input(false)
		color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		blur_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	)

func _change_scene(target_scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(target_scene)
