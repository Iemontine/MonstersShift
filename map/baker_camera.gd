extends Camera2D

@export var target: Player  # The player node to follow
@export var follow_speed: float = 1.0  # Speed at which the camera follows
@export var vertical_offset: float = -12.5  # Vertical offset for the camera
var base_zoom: Vector2
var cur_window_size: Vector2

func _ready() -> void:
	var window_size = get_viewport().get_visible_rect().size
	update_base_zoom(window_size)
	cur_window_size = window_size

func update_base_zoom(window_size: Vector2) -> void:
	base_zoom = Vector2(window_size.x / 1920.0, window_size.y / 1080.0)
	zoom = base_zoom

func _process(delta: float) -> void:
	# Handle dynamic window size changes
	var window_size = get_viewport().get_visible_rect().size
	if window_size != cur_window_size:
		update_base_zoom(window_size)
		cur_window_size = window_size

	# Smoothly follow the target in the Y direction
	if target:
		var target_y = target.position.y + vertical_offset
		position.y = lerp(position.y, target_y, follow_speed * delta)

	# Handle zoom adjustments
	if Input.is_key_pressed(KEY_KP_ADD) or Input.is_key_pressed(KEY_EQUAL):
		zoom += Vector2(0.06, 0.06) * base_zoom
	elif Input.is_key_pressed(KEY_KP_SUBTRACT) or Input.is_key_pressed(KEY_MINUS):
		zoom -= Vector2(0.06, 0.06) * base_zoom

	# Clamp zoom to prevent extreme values
	zoom.x = clamp(zoom.x, base_zoom.x * 4, base_zoom.x * 8)
	zoom.y = clamp(zoom.y, base_zoom.y * 4, base_zoom.y * 8)
