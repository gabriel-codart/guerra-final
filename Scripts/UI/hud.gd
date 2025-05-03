extends CanvasLayer

@onready var weapon_sprite: AnimatedSprite2D = $Weapon
@onready var health_bar: TextureProgressBar = $HealthBar
# Armas Enumeradas
enum Weapon { Default, Pistol }
var weapon_names = {
	Weapon.Default: "default",
	Weapon.Pistol: "pistol"
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
