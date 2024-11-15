extends Camera2D


@export var target: Player


func _physics_process(_delta: float) -> void:
	if target:
		
		position = target.position

		if Input.is_key_pressed(KEY_KP_ADD) or Input.is_key_pressed(KEY_EQUAL):
			zoom += Vector2(0.1, 0.1)
		elif Input.is_key_pressed(KEY_KP_SUBTRACT) or Input.is_key_pressed(KEY_MINUS):
			zoom -= Vector2(0.1, 0.1)

		zoom.x = clamp(zoom.x, 0.5, 7)
		zoom.y = clamp(zoom.y, 0.5, 7)	# 2 looks good as min
