extends TileMapLayer  # Attach this script to your TileMapLayer

@export var scroll_speed: float = 100.0  # Speed of scrolling in pixels/second
@export var tile_width: float = 1152.0  # Width of the scrolling segment (adjust to match your setup)

var distance_scrolled: float = 0.0  # Track the cumulative distance scrolled

func _process(delta: float) -> void:
	# Scroll the TileMap by updating position
	position.x -= scroll_speed * delta
	distance_scrolled += scroll_speed * delta

	# Reset when the total scrolled distance exceeds the tile width
	if distance_scrolled >= tile_width:
		position.x += tile_width  # Align back by the exact width
		distance_scrolled -= tile_width  # Reset scrolled distance
