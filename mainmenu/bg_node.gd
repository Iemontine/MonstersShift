extends Node  # Attach this to the parent node of your TileMap

@export var scroll_speed: float = 100.0  # Speed of scrolling in pixels/second
@export var tile_width: int = 64         # Width of one tile (adjust to your tileset size)

@onready var tilemap = $TileMap  # Ensure this matches the name of your TileMap node

func _process(delta: float) -> void:
	tilemap.position.x -= scroll_speed * delta  # Scroll the TileMap left
	if tilemap.position.x <= -tile_width:       # If a tile scrolls out of view
		tilemap.position.x += tile_width        # Reset its position
