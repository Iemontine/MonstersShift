extends Camera2D

@export var target: Player
var base_zoom: Vector2
var cur_window_size: Vector2

func _ready() -> void:
	var window_size = get_viewport().get_visible_rect().size
	update_base_zoom(window_size)

func update_base_zoom(window_size: Vector2) -> void:
	base_zoom = Vector2(window_size.x / 1920.0, window_size.y / 1080.0)
	zoom = base_zoom

func _process(_delta: float) -> void:
	var window_size = get_viewport().get_visible_rect().size
	if window_size != cur_window_size:
		update_base_zoom(window_size)
		cur_window_size = window_size

	if target:
		position = target.position + Vector2(0, -12.5)

		if Input.is_key_pressed(KEY_KP_ADD) or Input.is_key_pressed(KEY_EQUAL):
			zoom += Vector2(0.06, 0.06) * base_zoom
		elif Input.is_key_pressed(KEY_KP_SUBTRACT) or Input.is_key_pressed(KEY_MINUS):
			zoom -= Vector2(0.06, 0.06) * base_zoom

		zoom.x = clamp(zoom.x, base_zoom.x * 4, base_zoom.x * 8)
		zoom.y = clamp(zoom.y, base_zoom.y * 4, base_zoom.y * 8)
