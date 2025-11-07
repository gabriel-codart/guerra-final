extends CanvasLayer

# Controladores Prota
@onready var weapon_label: Label = $MarginContainer/LeftControl/MarginContainer/VBoxContainer/WeaponControl/Label
@onready var key_label: Label = $MarginContainer/LeftControl/MarginContainer/VBoxContainer/KeyControl/Label
@onready var health_bar: TextureProgressBar = $MarginContainer/LeftControl/MarginContainer/VBoxContainer/HealthControl/HealthBar
# Controladores Boss
@onready var boss_control: Control = $MarginContainer/RightControl
@onready var boss_name_label: Label = $MarginContainer/RightControl/MarginContainer/VBoxContainer/BossNameControl/Label
@onready var boss_health_bar: TextureProgressBar = $MarginContainer/RightControl/MarginContainer/VBoxContainer/BossHealthControl/HealthBar
# Controladores de Texto
@onready var text_label: RichTextLabel = $MarginContainer/TextControl/MarginContainer/MarginContainer/VBoxContainer/RichTextLabel
@onready var text_control: Control = $MarginContainer/TextControl
# Armas
@onready var weapon_names = Weapons.LABEL_NAMES
# Chaves
@onready var key_names = Keys.LABEL_NAMES
# Vida
var prota_max_health: int
var boss_max_health: int

func _ready():
	var protagonist: CharacterBody2D = get_parent().get_node("Protagonist") as CharacterBody2D
	if protagonist:
		prota_max_health = protagonist.maxHealth
		set_health(protagonist.health)
		set_weapon(protagonist.current_weapon)
		set_key(protagonist.current_key)
	var boss: CharacterBody2D = get_parent().get_node_or_null("Boss") as CharacterBody2D
	if boss:
		boss_max_health = boss.maxHealth
		set_boss_name(boss.boss_name)
		set_boss_health(boss.health)
	else:
		boss_control.queue_free()
	pass

# ====================
# Controladores Prota
# ====================

func set_weapon(weapon: Weapons.Type) -> void:
	#weapon_sprite.play(weapon_names[weapon])
	weapon_label.text = weapon_names[weapon]

func set_key(key: Keys.Type) -> void:
	#key_sprite.play(key_names[key])
	key_label.text = key_names[key]

func set_health(health: int) -> void:
	@warning_ignore("integer_division")
	health_bar.value = health * 100 / prota_max_health

# ====================
# Controladores Boss
# ====================

func set_boss_name(boss_name: StringName) -> void:
	boss_name_label.text = boss_name.to_upper()

func set_boss_health(health: int) -> void:
	@warning_ignore("integer_division")
	boss_health_bar.value = health * 100 / boss_max_health

# ====================
# Controlador de Texto
# ====================
func set_text(text: String) -> void:
	text_label.text = text
	if text == "":
		text_control.visible = false
	else:
		text_control.visible = true
