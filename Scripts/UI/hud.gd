extends CanvasLayer

@onready var weapon_sprite: AnimatedSprite2D = $MarginContainer/LeftControl/MarginContainer/VBoxContainer/WeaponControl/Weapon
@onready var key_sprite: AnimatedSprite2D = $MarginContainer/RightControl/MarginContainer/VBoxContainer/KeyControl/Key
@onready var health_bar: TextureProgressBar = $MarginContainer/LeftControl/MarginContainer/VBoxContainer/HealthBar
@onready var text_label: RichTextLabel = $MarginContainer/TextControl/MarginContainer/MarginContainer/VBoxContainer/RichTextLabel
@onready var text_control: Control = $MarginContainer/TextControl
# Armas
@onready var weapon_names = Weapons.NAMES
# Chaves
@onready var key_names = Keys.NAMES
# Vida
var max_health: int

func _ready():
	var protagonist: CharacterBody2D = get_parent().get_node("Protagonist") as CharacterBody2D
	if protagonist:
		max_health = protagonist.maxHealth
		set_health(protagonist.health)
		set_weapon(protagonist.current_weapon)
		set_key(protagonist.current_key)
	pass

func _process(_delta):
	var protagonist: CharacterBody2D = get_parent().get_node("Protagonist") as CharacterBody2D
	if protagonist:
		health_bar.value = protagonist.health * 100 / protagonist.maxHealth

func set_weapon(weapon: Weapons.Type) -> void:
	weapon_sprite.play(weapon_names[weapon])

func set_key(key: Keys.Type) -> void:
	key_sprite.play(key_names[key])

func set_health(health: int) -> void:
	@warning_ignore("integer_division")
	health_bar.value = health * 100 / max_health

func set_text(text: String) -> void:
	text_label.text = text
	if text == "":
		text_control.visible = false
	else:
		text_control.visible = true
