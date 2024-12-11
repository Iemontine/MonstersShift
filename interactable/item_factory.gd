extends Interactable
class_name Factory

@export var item_name: String
@export var item_texture: Texture2D
@export var item_region_rect: Rect2
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	produce_item()
	super()

func _on_interacted() -> void:
	PlayerController.start_cutscene("how_to_play")
	# TODO: ensure only 1 item is available at any given time, currently multiple can be produced if the player is holding something
	produce_item()

func produce_item() -> void:
	var item_pickup = create_item_pickup()
	add_child(item_pickup)
	audio_player.play()

func play_audio(audio_path: String) -> void:
	var audio_stream = AudioStreamPlayer.new()
	audio_stream.stream = load(audio_path)
	add_child(audio_stream)
	audio_stream.play()

func create_item_pickup() -> Node:
	var item_pickup = load("res://interactable/item_pickup.tscn").instantiate()
	item_pickup.item_name = item_name
	var sprite = item_pickup.get_node("Sprite2D")
	sprite.texture = item_texture
	sprite.region_enabled = true
	sprite.region_rect = item_region_rect
	sprite.z_index = 1
	sprite.y_sort_enabled = true
	return item_pickup
