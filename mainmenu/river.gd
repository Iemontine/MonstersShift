extends TileMapLayer  # Attach this script to your TileMap

@export var scroll_speed: float = 50.0  # Speed of scrolling in pixels/second
@export var tile_width: int = 64         # Width of one tile (adjust based on tileset size)

func _process(delta: float) -> void:
	position.x -= scroll_speed * delta  # Move the TileMap left
	if position.x <= -tile_width:       # Reset position when a tile scrolls out
		position.x += tile_width
