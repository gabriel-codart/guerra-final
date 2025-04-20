extends Marker2D

func _ready():
	pass

func _process(_delta):
	pass

func set_axis(weapon: String, state: String) -> void:
	if weapon == "pistol":
		if state == "in_air":
			position.x = 38
			position.y = 12
			return
		position.x = 22
		position.y = 19
