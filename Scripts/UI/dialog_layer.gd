extends CanvasLayer

signal dialog_response(accepted: bool)

@onready var title_label: Label = $PanelContainer/MarginContainer/VBoxContainer/Title
@onready var message_label: Label = $PanelContainer/MarginContainer/VBoxContainer/Message
@onready var confirm_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ConfirmButton
@onready var cancel_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/CancelButton

var _is_open: bool = false

func _ready() -> void:
	visible = false
	confirm_button.pressed.connect(_on_confirm_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)

func show_dialog(title: String, text: String, confirm_text: String = "Confirmar", cancel_text: String = "Cancelar") -> bool:
	_is_open = true
	visible = true
	
	title_label.text = title
	message_label.text = text
	confirm_button.text = confirm_text
	cancel_button.text = cancel_text
	
	return await self.dialog_response  # <-- retorna a resposta como sinal (awaitável)

func _on_confirm_pressed() -> void:
	visible = false
	_is_open = false
	dialog_response.emit(true)

func _on_cancel_pressed() -> void:
	visible = false
	_is_open = false
	dialog_response.emit(false)
