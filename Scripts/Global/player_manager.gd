extends Node

var health: int
var current_weapon: Weapons.Type
var current_key: Keys.Type
var current_progress: int

func _ready() -> void:
	health = 2
	current_weapon = Weapons.Type.Default
	current_key = Keys.Type.Empty
	current_progress = 1
