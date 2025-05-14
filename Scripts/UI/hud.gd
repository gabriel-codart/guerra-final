extends CanvasLayer

@warning_ignore("integer_division")
@onready var weapon_sprite: AnimatedSprite2D = $Weapon
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var text_label: RichTextLabel = $MarginContainer/RichTextLabel
# Armas Enumeradas
enum Weapon { Default, Pistol, SMG, Shotgun, Rassault }
var weapon_names = {
	Weapon.Default: "default",
	Weapon.Pistol: "pistol",
	Weapon.SMG: "smg",
	Weapon.Shotgun: "shotgun",
	Weapon.Rassault: "rassault",
}
# Vida
var max_health: int

func _ready():
	var protagonist: CharacterBody2D = get_parent().get_node("Protagonist") as CharacterBody2D
	if protagonist:
		max_health = protagonist.maxHealth
		set_health(protagonist.health)
	pass

func _process(_delta):
	var protagonist: CharacterBody2D = get_parent().get_node("Protagonist") as CharacterBody2D
	if protagonist:
		health_bar.value = protagonist.health * 100 / protagonist.maxHealth

func set_weapon(weapon: Weapon) -> void:
	weapon_sprite.play(weapon_names[weapon])

func set_health(health: int) -> void:
	health_bar.value = health * 100 / max_health

func set_text(text: String) -> void:
	text_label.text = text
