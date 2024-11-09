extends Camera2D

@export var target: Player

func _physics_process(_delta: float) -> void:
	if target:
		position = target.position

		var zoom_change = 0.0
		if Input.is_key_pressed(KEY_KP_ADD) or Input.is_key_pressed(KEY_EQUAL):
			zoom_change = 0.1
		elif Input.is_key_pressed(KEY_KP_SUBTRACT) or Input.is_key_pressed(KEY_MINUS):
			zoom_change = -0.1

		if zoom_change != 0.0:
			zoom += Vector2(zoom_change, zoom_change)
			zoom.x = clamp(zoom.x, 0.5, 7)
			zoom.y = clamp(zoom.y, 0.5, 7)