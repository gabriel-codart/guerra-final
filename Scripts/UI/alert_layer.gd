extends CanvasLayer

const ALERT_DURATION := 1.5 # segundos

@onready var alert_container: VBoxContainer = $MarginContainer/VBoxContainer

enum AlertType { DEFAULT, SUCCESS, WARNING, ERROR }

# Exemplo de uso:
# AlertManager.show_alert("Progresso salvo com sucesso!", AlertManager.AlertType.SUCCESS)

func show_alert(message: String, alert_type: AlertType = AlertType.DEFAULT) -> void:
	var alert := create_alert_label(message, alert_type)
	alert_container.add_child(alert)

	# Fade-out automático
	var tween := create_tween()
	tween.tween_property(alert, "modulate:a", 0.0, 1.0).set_delay(ALERT_DURATION)
	tween.finished.connect(alert.queue_free)

func create_alert_label(message: String, alert_type: AlertType) -> Label:
	var label := Label.new()
	label.text = message
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	label.add_theme_font_size_override("font_size", 8)
	label.modulate.a = 0.9 # leve transparência
	
	# Define o estilo de acordo com o tipo
	match alert_type:
		AlertType.SUCCESS:
			label.add_theme_color_override("font_color", Color.WHITE)
			label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
			label.add_theme_stylebox_override("normal", create_stylebox(Color(0.2, 0.6, 0.2)))
		AlertType.WARNING:
			label.add_theme_color_override("font_color", Color.BLACK)
			label.add_theme_stylebox_override("normal", create_stylebox(Color(1, 1, 0.4)))
		AlertType.ERROR:
			label.add_theme_color_override("font_color", Color.WHITE)
			label.add_theme_stylebox_override("normal", create_stylebox(Color(0.8, 0.1, 0.1)))
		_:
			label.add_theme_color_override("font_color", Color.BLACK)
			label.add_theme_stylebox_override("normal", create_stylebox(Color(1, 1, 1)))
	
	return label

func create_stylebox(color: Color) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = color
	sb.content_margin_left = 8
	sb.content_margin_right = 8
	sb.content_margin_top = 4
	sb.content_margin_bottom = 4
	return sb
