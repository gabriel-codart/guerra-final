extends CanvasLayer

@onready var health_bar: TextureProgressBar = $HealthBar

func _ready():
	pass

func _process(delta):
	var protagonist: CharacterBody2D = get_parent().get_node("Protagonist") as CharacterBody2D
	if protagonist:
		health_bar.value = protagonist.health * 100 / protagonist.maxHealth
