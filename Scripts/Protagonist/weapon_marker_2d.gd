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
	elif weapon == "smg":
		if state == "in_air":
			position.x = 26
			position.y = 11
			return
		position.x = 11
		position.y = 22
	elif weapon == "shotgun":
		position.x = 20
		position.y = 21
	elif weapon == "rassault":
		position.x = 19
		position.y = 22
