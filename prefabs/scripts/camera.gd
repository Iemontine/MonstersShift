extends Camera2D


@export var target: Player


func _process(_delta: float) -> void:
	if target:
		
		position = target.position + Vector2(0, -10)

		if Input.is_key_pressed(KEY_KP_ADD) or Input.is_key_pressed(KEY_EQUAL):
			zoom += Vector2(0.06, 0.06)
		elif Input.is_key_pressed(KEY_KP_SUBTRACT) or Input.is_key_pressed(KEY_MINUS):
			zoom -= Vector2(0.06, 0.06)

		zoom.x = clamp(zoom.x, 4, 8)
		zoom.y = clamp(zoom.y, 4, 8)	# 2 looks good as min
